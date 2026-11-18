import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class MedicationService {
  MedicationService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  // =====================================================
  // 1. HELPER TANGGAL DAN WAKTU
  // =====================================================

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}:'
        '${date.second.toString().padLeft(2, '0')}';
  }

  int _timeToMinutes(String value) {
    debugPrint('RAW DATABASE TIME: [$value]');

    final normalized = value.trim().replaceAll('.', ':');
    debugPrint('NORMALIZED TIME: [$normalized]');

    final parts = normalized.split(':');

    if (parts.length < 2) {
      throw Exception('Format waktu database tidak valid: [$value]');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw Exception('Waktu tidak valid: [$value]');
    }

    return hour * 60 + minute;
  }

  String _minutesToTime(int minutes) {
    if (minutes < 0 || minutes >= 1440) {
      throw Exception(
        'Penyesuaian melewati batas hari. '
        'Jadwal tidak dapat digeser otomatis.',
      );
    }

    final hour = minutes ~/ 60;
    final minute = minutes % 60;

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:00';
  }

  String _normalizeTime(String value) {
    final normalized = value.replaceAll('.', ':');
    final minutes = _timeToMinutes(normalized);

    return _minutesToTime(minutes);
  }

  // =====================================================
  // 2. VALIDASI MASA AKTIF OBAT
  // =====================================================

  bool _isMedicationActive(Map<String, dynamic> medication, DateTime date) {
    final createdAtValue = medication['created_at'];

    if (createdAtValue == null) return false;

    final createdAt = DateTime.parse(createdAtValue.toString());

    final startDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    final days = (medication['days'] as num?)?.toInt() ?? 0;

    if (days <= 0) return false;

    final endDate = startDate.add(Duration(days: days));

    final checkDate = DateTime(date.year, date.month, date.day);

    return !checkDate.isBefore(startDate) && checkDate.isBefore(endDate);
  }

  // =====================================================
  // 3. VALIDASI KEPEMILIKAN JADWAL
  // =====================================================

  Future<Map<String, dynamic>> _getOwnedSchedule(String scheduleId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final schedule = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, is_active')
        .eq('id', scheduleId)
        .maybeSingle();

    if (schedule == null) {
      throw Exception('Jadwal obat tidak ditemukan.');
    }

    if (schedule['is_active'] != true) {
      throw Exception('Jadwal obat sudah tidak aktif.');
    }

    final medication = await _supabase
        .from('medications')
        .select('id, name, dose, days, created_at')
        .eq('id', schedule['medication_id'])
        .eq('user_id', user.id)
        .maybeSingle();

    if (medication == null) {
      throw Exception('Anda tidak memiliki akses ke jadwal obat ini.');
    }

    if (!_isMedicationActive(medication, DateTime.now())) {
      throw Exception('Masa penggunaan obat sudah berakhir.');
    }

    return {
      'schedule': Map<String, dynamic>.from(schedule),
      'medication': Map<String, dynamic>.from(medication),
    };
  }

  // =====================================================
  // 4. MENGAMBIL STATUS AKTIVITAS HARI INI
  // =====================================================

  Future<Map<String, String>> _getTodayActivityStatuses(
    List<String> scheduleIds,
  ) async {
    if (scheduleIds.isEmpty) return {};

    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    final histories = await _supabase
        .from('activity_histories')
        .select('medication_schedule_id, status, activity_time')
        .inFilter('medication_schedule_id', scheduleIds)
        .gte('activity_time', '${_formatDate(startOfDay)} 00:00:00')
        .lt('activity_time', '${_formatDate(startOfTomorrow)} 00:00:00')
        .order('activity_time', ascending: false);

    final Map<String, String> statuses = {};

    for (final history in histories) {
      final id = history['medication_schedule_id']?.toString();
      final status = history['status']?.toString();

      if (id == null || status == null) continue;

      statuses.putIfAbsent(id, () => status);
    }

    return statuses;
  }

  // =====================================================
  // 5. MENGAMBIL SEMUA JADWAL OBAT HARI INI
  // =====================================================

  Future<List<Map<String, dynamic>>> getTodaySchedules() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final now = DateTime.now();
    final today = _formatDate(now);

    final medications = await _supabase
        .from('medications')
        .select('id, name, dose, days, created_at')
        .eq('user_id', user.id);

    if (medications.isEmpty) return [];

    // Hanya mengambil obat yang masih dalam masa penggunaan.
    final activeMedications = medications.where((item) {
      return _isMedicationActive(item, now);
    }).toList();

    if (activeMedications.isEmpty) return [];

    final medicationMap = {
      for (final medication in activeMedications)
        medication['id'].toString(): Map<String, dynamic>.from(medication),
    };

    final medicationIds = medicationMap.keys.toList();

    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, meal_instruction, is_active')
        .inFilter('medication_id', medicationIds)
        .eq('is_active', true);

    if (schedules.isEmpty) return [];

    final scheduleIds = schedules.map((item) => item['id'].toString()).toList();

    // Mengambil override hari ini.
    final overrides = await _supabase
        .from('medication_schedule_overrides')
        .select('medication_schedule_id, schedule_time')
        .inFilter('medication_schedule_id', scheduleIds)
        .eq('override_date', today);

    final overrideMap = {
      for (final item in overrides)
        item['medication_schedule_id'].toString(): item['schedule_time']
            .toString(),
    };

    // Mengambil status taken dan skipped.
    final statuses = await _getTodayActivityStatuses(scheduleIds);

    final result = <Map<String, dynamic>>[];

    for (final schedule in schedules) {
      final medication = medicationMap[schedule['medication_id'].toString()];

      if (medication == null) continue;

      final id = schedule['id'].toString();
      final adjustedTime = overrideMap[id];
      final activityStatus = statuses[id];

      result.add({
        ...Map<String, dynamic>.from(schedule),
        'schedule_time': adjustedTime ?? schedule['schedule_time'],
        'original_schedule_time': schedule['schedule_time'],
        'is_adjusted': adjustedTime != null,
        'medication_name': medication['name'],
        'medication_dose': medication['dose'],
        'medication_days': medication['days'],
        'medication_created_at': medication['created_at'],
        'activity_status': activityStatus,
        'is_taken': activityStatus == 'taken',
        'is_skipped': activityStatus == 'skipped',
      });
    }

    result.sort((a, b) {
      return a['schedule_time'].toString().compareTo(
        b['schedule_time'].toString(),
      );
    });

    return result;
  }

  // =====================================================
  // 6. MENGAMBIL JADWAL BERDASARKAN ID OBAT
  // =====================================================

  Future<List<Map<String, dynamic>>> getMedicationSchedules(
    String medicationId,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final medication = await _supabase
        .from('medications')
        .select('id, name, dose, days, created_at')
        .eq('id', medicationId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (medication == null) {
      throw Exception('Data obat tidak ditemukan.');
    }

    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, meal_instruction, is_active')
        .eq('medication_id', medicationId)
        .order('schedule_time');

    return schedules.map<Map<String, dynamic>>((schedule) {
      return {
        ...Map<String, dynamic>.from(schedule),
        'medication_name': medication['name'],
        'medication_dose': medication['dose'],
        'medication_days': medication['days'],
        'medication_created_at': medication['created_at'],
      };
    }).toList();
  }

  // =====================================================
  // 7. PENYESUAIAN JADWAL BERANTAI KHUSUS HARI INI
  // =====================================================

  Future<void> saveScheduleOverride({
    required String scheduleId,
    required String newTime,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final now = DateTime.now();
    final today = _formatDate(now);

    final selectedTime = _timeToMinutes(_normalizeTime(newTime));

    // Validasi kepemilikan jadwal dan obat.
    final ownedData = await _getOwnedSchedule(scheduleId);

    final selectedSchedule = ownedData['schedule'] as Map<String, dynamic>;

    final medication = ownedData['medication'] as Map<String, dynamic>;

    final medicationId = medication['id'].toString();

    // Ambil seluruh jadwal aktif dari obat yang sama.
    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, is_active')
        .eq('medication_id', medicationId)
        .eq('is_active', true)
        .order('schedule_time');

    if (schedules.isEmpty) {
      throw Exception('Tidak ada jadwal aktif.');
    }

    final scheduleIds = schedules.map((item) => item['id'].toString()).toList();

    // Ambil override yang sudah tersimpan hari ini.
    final overrides = await _supabase
        .from('medication_schedule_overrides')
        .select('medication_schedule_id, schedule_time')
        .inFilter('medication_schedule_id', scheduleIds)
        .eq('override_date', today);

    final overrideMap = {
      for (final item in overrides)
        item['medication_schedule_id'].toString(): item['schedule_time']
            .toString(),
    };

    // Jangan mengubah jadwal yang sudah diminum atau dilewati.
    final statuses = await _getTodayActivityStatuses(scheduleIds);

    final selectedId = selectedSchedule['id'].toString();

    if (statuses.containsKey(selectedId)) {
      throw Exception('Jadwal ini sudah memiliki catatan aktivitas hari ini.');
    }

    // Waktu efektif jadwal terpilih, yaitu override jika tersedia.
    final selectedEffectiveTime =
        overrideMap[selectedId] ?? selectedSchedule['schedule_time'].toString();

    final originalSelectedMinutes = _timeToMinutes(selectedEffectiveTime);

    // Hitung selisih dari waktu yang sedang berlaku.
    final shiftMinutes = selectedTime - originalSelectedMinutes;

    if (shiftMinutes == 0) {
      return;
    }

    // Siapkan seluruh perubahan terlebih dahulu.
    // Tidak ada data yang ditulis jika salah satu jadwal
    // melewati batas hari.
    final updates = <Map<String, dynamic>>[];

    for (final schedule in schedules) {
      final id = schedule['id'].toString();

      final effectiveTime =
          overrideMap[id] ?? schedule['schedule_time'].toString();

      final currentMinutes = _timeToMinutes(effectiveTime);

      // Hanya jadwal terpilih dan jadwal setelahnya.
      if (currentMinutes < originalSelectedMinutes) {
        continue;
      }

      // Jadwal yang sudah memiliki keputusan akhir tidak digeser.
      if (statuses.containsKey(id)) {
        continue;
      }

      final shiftedMinutes = currentMinutes + shiftMinutes;

      // Validasi seluruh jadwal sebelum melakukan upsert.
      if (shiftedMinutes < 0 || shiftedMinutes >= 1440) {
        throw Exception(
          'Penyesuaian akan melewati batas hari. '
          'Jadwal rutin tidak diubah. '
          'Silakan pilih penanganan lain sesuai petunjuk obat.',
        );
      }

      updates.add({
        'medication_schedule_id': id,
        'override_date': today,
        'schedule_time': _minutesToTime(shiftedMinutes),
        'updated_at': now.toIso8601String(),
      });
    }

    if (updates.isEmpty) {
      throw Exception('Tidak ada jadwal yang dapat disesuaikan.');
    }

    // Simpan seluruh override menggunakan unique constraint
    // medication_schedule_id + override_date.
    await _supabase
        .from('medication_schedule_overrides')
        .upsert(updates, onConflict: 'medication_schedule_id,override_date');
  }

  // =====================================================
  // 8. MENGAMBIL JADWAL DENGAN OVERRIDE HARI INI
  // =====================================================

  Future<List<Map<String, dynamic>>> getMedicationSchedulesWithOverrides(
    String medicationId,
  ) async {
    final schedules = await getMedicationSchedules(medicationId);

    if (schedules.isEmpty) return schedules;

    final now = DateTime.now();
    final today = _formatDate(now);

    final scheduleIds = schedules.map((item) => item['id'].toString()).toList();

    final overrides = await _supabase
        .from('medication_schedule_overrides')
        .select('medication_schedule_id, schedule_time')
        .inFilter('medication_schedule_id', scheduleIds)
        .eq('override_date', today);

    final overrideMap = {
      for (final item in overrides)
        item['medication_schedule_id'].toString(): item['schedule_time']
            .toString(),
    };

    final statuses = await _getTodayActivityStatuses(scheduleIds);

    return schedules.map((schedule) {
      final result = Map<String, dynamic>.from(schedule);
      final id = schedule['id'].toString();

      final adjustedTime = overrideMap[id];
      final activityStatus = statuses[id];

      result['original_schedule_time'] = schedule['schedule_time'];

      result['schedule_time'] = adjustedTime ?? schedule['schedule_time'];

      result['is_adjusted'] = adjustedTime != null;
      result['activity_status'] = activityStatus;
      result['is_taken'] = activityStatus == 'taken';
      result['is_skipped'] = activityStatus == 'skipped';

      return result;
    }).toList();
  }

  // =====================================================
  // 9. MENCATAT OBAT SUDAH DIMINUM
  // =====================================================

  Future<void> markMedicationAsTaken({required String scheduleId}) async {
    await _recordMedicationActivity(scheduleId: scheduleId, status: 'taken');
  }

  // =====================================================
  // 10. MENCATAT JADWAL OBAT DILEWATI
  // =====================================================

  Future<void> markMedicationAsSkipped({required String scheduleId}) async {
    await _recordMedicationActivity(scheduleId: scheduleId, status: 'skipped');
  }

  // =====================================================
  // 11. PENYIMPANAN AKTIVITAS OBAT
  // =====================================================

  Future<void> _recordMedicationActivity({
    required String scheduleId,
    required String status,
  }) async {
    if (status != 'taken' && status != 'skipped') {
      throw Exception('Status aktivitas tidak valid.');
    }

    // Memastikan jadwal dimiliki pengguna dan obat masih aktif.
    await _getOwnedSchedule(scheduleId);

    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final startOfTomorrow = startOfDay.add(const Duration(days: 1));

    // Cegah pencatatan ganda.
    final existing = await _supabase
        .from('activity_histories')
        .select('id, status')
        .eq('medication_schedule_id', scheduleId)
        .gte('activity_time', '${_formatDate(startOfDay)} 00:00:00')
        .lt('activity_time', '${_formatDate(startOfTomorrow)} 00:00:00')
        .limit(1);

    if (existing.isNotEmpty) {
      final existingStatus = existing.first['status'];

      if (existingStatus == 'taken') {
        throw Exception('Jadwal ini sudah dicatat sebagai diminum hari ini.');
      }

      if (existingStatus == 'skipped') {
        throw Exception('Jadwal ini sudah dilewati hari ini.');
      }

      throw Exception('Jadwal ini sudah memiliki catatan aktivitas hari ini.');
    }

    // Simpan aktivitas ke Supabase.
    await _supabase.from('activity_histories').insert({
      'medication_schedule_id': scheduleId,
      'meal_schedule_id': null,
      'status': status,
      'activity_time': _formatDateTime(now),
    });
  }
}
