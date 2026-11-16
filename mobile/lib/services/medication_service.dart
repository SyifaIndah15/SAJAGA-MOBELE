import 'package:supabase_flutter/supabase_flutter.dart';

class MedicationService {
  MedicationService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  // =====================================================
  // 1. MENGAMBIL SEMUA JADWAL OBAT PENGGUNA
  // =====================================================

  Future<List<Map<String, dynamic>>> getTodaySchedules() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // Mengambil obat milik pengguna.
    final medications = await _supabase
        .from('medications')
        .select('id, name, dose, days')
        .eq('user_id', user.id);

    if (medications.isEmpty) return [];

    final medicationIds = medications
        .map<String>((item) => item['id'].toString())
        .toList();

    // Mengambil seluruh jadwal aktif.
    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, meal_instruction, is_active')
        .inFilter('medication_id', medicationIds)
        .eq('is_active', true);

    if (schedules.isEmpty) return [];

    // Tanggal lokal perangkat.
    final now = DateTime.now();

    final today =
        '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    // Mengambil penyesuaian jadwal khusus hari ini.
    final scheduleIds = schedules
        .map<String>((item) => item['id'].toString())
        .toList();

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

    // Pemetaan data obat.
    final medicationMap = {
      for (final medication in medications)
        medication['id'].toString(): Map<String, dynamic>.from(medication),
    };

    final List<Map<String, dynamic>> result = [];

    for (final schedule in schedules) {
      final medication = medicationMap[schedule['medication_id'].toString()];

      if (medication == null) continue;

      final scheduleId = schedule['id'].toString();
      final adjustedTime = overrideMap[scheduleId];

      result.add({
        ...Map<String, dynamic>.from(schedule),
        'schedule_time': adjustedTime ?? schedule['schedule_time'],
        'is_adjusted': adjustedTime != null,
        'medication_name': medication['name'],
        'medication_dose': medication['dose'],
        'medication_days': medication['days'],
      });
    }

    // Mengurutkan berdasarkan waktu terbaru.
    // Ambil aktivitas konsumsi obat untuk tanggal hari ini.
    final histories = await _supabase
        .from('activity_histories')
        .select('medication_schedule_id')
        .inFilter('medication_schedule_id', scheduleIds)
        .eq('status', 'taken')
        .gte('activity_time', '$today 00:00:00')
        .lt(
          'activity_time',
          '${DateTime(now.year, now.month, now.day + 1).year}-'
              '${DateTime(now.year, now.month, now.day + 1).month.toString().padLeft(2, '0')}-'
              '${DateTime(now.year, now.month, now.day + 1).day.toString().padLeft(2, '0')} 00:00:00',
        );

    final takenScheduleIds = histories
        .map((item) => item['medication_schedule_id'].toString())
        .toSet();

    for (final schedule in result) {
      schedule['is_taken'] = takenScheduleIds.contains(
        schedule['id'].toString(),
      );
    }
    result.sort((a, b) {
      return a['schedule_time'].toString().compareTo(
        b['schedule_time'].toString(),
      );
    });

    return result;
  }

  // =====================================================
  // 2. MENGAMBIL JADWAL BERDASARKAN ID OBAT
  // =====================================================

  Future<List<Map<String, dynamic>>> getMedicationSchedules(
    String medicationId,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // Memastikan obat milik pengguna yang sedang login.
    final medication = await _supabase
        .from('medications')
        .select('id, name, dose, days')
        .eq('id', medicationId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (medication == null) {
      throw Exception('Data obat tidak ditemukan.');
    }

    // Mengambil jadwal berdasarkan medication_id.
    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, meal_instruction, is_active')
        .eq('medication_id', medicationId)
        .order('schedule_time');

    // Menggabungkan data obat dengan jadwal.
    return schedules.map<Map<String, dynamic>>((schedule) {
      return {
        ...Map<String, dynamic>.from(schedule),
        'medication_name': medication['name'],
        'medication_dose': medication['dose'],
        'medication_days': medication['days'],
      };
    }).toList();
  }

  // =====================================================
  // 3. MENYIMPAN PERUBAHAN SATU JADWAL UNTUK HARI INI
  // =====================================================

  Future<void> saveScheduleOverride({
    required String scheduleId,
    required String newTime,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // Mendukung format HH.mm maupun HH:mm.
    final normalizedTime = newTime.replaceAll('.', ':');
    final parts = normalizedTime.split(':');

    if (parts.length != 2) {
      throw Exception('Format waktu tidak valid.');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw Exception('Waktu yang dipilih tidak valid.');
    }

    final formattedTime =
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:00';

    // Tanggal lokal perangkat.
    final now = DateTime.now();

    final today =
        '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    // Periksa jadwal yang akan diubah.
    final schedule = await _supabase
        .from('medication_schedules')
        .select('id, medication_id')
        .eq('id', scheduleId)
        .maybeSingle();

    if (schedule == null) {
      throw Exception('Jadwal obat tidak ditemukan.');
    }

    // Pastikan jadwal merupakan milik pengguna yang login.
    final medication = await _supabase
        .from('medications')
        .select('id')
        .eq('id', schedule['medication_id'])
        .eq('user_id', user.id)
        .maybeSingle();

    if (medication == null) {
      throw Exception('Anda tidak memiliki akses ke jadwal obat ini.');
    }
    // Simpan hanya satu jadwal yang dipilih.
    await _supabase.from('medication_schedule_overrides').upsert({
      'medication_schedule_id': scheduleId,
      'override_date': today,
      'schedule_time': formattedTime,
      'updated_at': now.toIso8601String(),
    }, onConflict: 'medication_schedule_id,override_date');
  }

  // =====================================================
  // 4. MENGAMBIL JADWAL DENGAN PENYESUAIAN HARI INI
  // =====================================================

  Future<List<Map<String, dynamic>>> getMedicationSchedulesWithOverrides(
    String medicationId,
  ) async {
    // Ambil jadwal rutin terlebih dahulu.
    final schedules = await getMedicationSchedules(medicationId);

    final now = DateTime.now();

    final today =
        '${now.year}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';

    if (schedules.isEmpty) return schedules;

    // Ambil semua ID jadwal.
    final scheduleIds = schedules.map((item) => item['id'].toString()).toList();

    // Cari perubahan jadwal khusus hari ini.
    final overrides = await _supabase
        .from('medication_schedule_overrides')
        .select('medication_schedule_id, schedule_time, override_date')
        .inFilter('medication_schedule_id', scheduleIds)
        .eq('override_date', today);

    // Buat pemetaan perubahan berdasarkan ID jadwal.
    final overrideMap = {
      for (final item in overrides)
        item['medication_schedule_id'].toString(): item['schedule_time']
            .toString(),
    };

    // Terapkan perubahan hanya pada jadwal yang memiliki override.
    return schedules.map((schedule) {
      final result = Map<String, dynamic>.from(schedule);
      final scheduleId = schedule['id'].toString();

      if (overrideMap.containsKey(scheduleId)) {
        result['schedule_time'] = overrideMap[scheduleId];
        result['is_adjusted'] = true;
      } else {
        result['is_adjusted'] = false;
      }

      return result;
    }).toList();
  }

  Future<void> markMedicationAsTaken({required String scheduleId}) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // Ambil jadwal berdasarkan ID.
    final schedule = await _supabase
        .from('medication_schedules')
        .select('id, medication_id')
        .eq('id', scheduleId)
        .maybeSingle();

    if (schedule == null) {
      throw Exception('Jadwal obat tidak ditemukan.');
    }

    // Pastikan obat merupakan milik pengguna yang login.
    final medication = await _supabase
        .from('medications')
        .select('id')
        .eq('id', schedule['medication_id'])
        .eq('user_id', user.id)
        .maybeSingle();

    if (medication == null) {
      throw Exception('Pengguna tidak memiliki akses ke jadwal obat ini.');
    }

    // Catat waktu aktual konsumsi berdasarkan waktu lokal perangkat.
    final now = DateTime.now();

    final activityTime =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';

    // Simpan aktivitas konsumsi obat.
    await _supabase.from('activity_histories').insert({
      'medication_schedule_id': scheduleId,
      'meal_schedule_id': null,
      'status': 'taken',
      'activity_time': activityTime,
    });
  }
}
