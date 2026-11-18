import 'package:supabase_flutter/supabase_flutter.dart';

class MealService {
  MealService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  String _formatTime(String time) {
    final normalized = time.trim().replaceAll('.', ':');
    final parts = normalized.split(':');

    if (parts.length != 2 && parts.length != 3) {
      throw Exception('Format waktu makan tidak valid: $time');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    final second = parts.length == 3 ? int.tryParse(parts[2]) : 0;

    if (hour == null ||
        minute == null ||
        second == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        second < 0 ||
        second > 59) {
      throw Exception('Waktu makan tidak valid: $time');
    }

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:'
        '${second.toString().padLeft(2, '0')}';
  }

  Future<String> _requireUserId() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    return user.id;
  }

  // Mengambil seluruh jadwal makan pengguna.
  Future<List<Map<String, dynamic>>> getMealSchedules() async {
    final userId = await _requireUserId();

    final response = await _supabase
        .from('meal_schedules')
        .select('id, user_id, meal_type, schedule_time, is_active')
        .eq('user_id', userId)
        .order('schedule_time');

    return response
        .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  // Menyimpan atau memperbarui satu jadwal makan.
  Future<void> saveMealSchedule({
    required String mealType,
    required String scheduleTime,
    required bool isActive,
  }) async {
    final userId = await _requireUserId();

    const allowedTypes = ['breakfast', 'lunch', 'dinner'];

    if (!allowedTypes.contains(mealType)) {
      throw Exception('Jenis jadwal makan tidak valid.');
    }

    final formattedTime = _formatTime(scheduleTime);

    final existing = await _supabase
        .from('meal_schedules')
        .select('id')
        .eq('user_id', userId)
        .eq('meal_type', mealType);

    if (existing.length > 1) {
      throw Exception(
        'Ditemukan jadwal $mealType yang duplikat. '
        'Data perlu diperiksa terlebih dahulu.',
      );
    }

    final now = DateTime.now().toIso8601String();

    final data = {
      'user_id': userId,
      'meal_type': mealType,
      'schedule_time': formattedTime,
      'is_active': isActive,
      'updated_at': now,
    };

    if (existing.length == 1) {
      await _supabase
          .from('meal_schedules')
          .update(data)
          .eq('id', existing.first['id']);
    } else {
      await _supabase.from('meal_schedules').insert(data);
    }
  }

  // Menyimpan tiga jadwal makan.
  Future<void> saveAllMealSchedules({
    required String breakfastTime,
    required bool breakfastActive,
    required String lunchTime,
    required bool lunchActive,
    required String dinnerTime,
    required bool dinnerActive,
  }) async {
    await saveMealSchedule(
      mealType: 'breakfast',
      scheduleTime: breakfastTime,
      isActive: breakfastActive,
    );

    await saveMealSchedule(
      mealType: 'lunch',
      scheduleTime: lunchTime,
      isActive: lunchActive,
    );

    await saveMealSchedule(
      mealType: 'dinner',
      scheduleTime: dinnerTime,
      isActive: dinnerActive,
    );
  }

  // Mencatat aktivitas makan setelah pengguna menekan Sudah Makan.
  // Return true jika berhasil, false jika sudah tercatat hari ini.
  Future<bool> recordMealActivity({required String mealScheduleId}) async {
    final userId = await _requireUserId();

    // Ambil jadwal, termasuk schedule_time.
    final schedule = await _supabase
        .from('meal_schedules')
        .select('id, user_id, schedule_time, is_active')
        .eq('id', mealScheduleId)
        .eq('user_id', userId)
        .maybeSingle();

    if (schedule == null) {
      throw Exception('Jadwal makan tidak ditemukan.');
    }

    if (schedule['is_active'] != true) {
      throw Exception('Jadwal makan sedang tidak aktif.');
    }

    // Waktu lokal perangkat.
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    // Periksa aktivitas yang sudah tercatat hari ini.
    final existingActivity = await _supabase
        .from('activity_histories')
        .select('id')
        .eq('meal_schedule_id', mealScheduleId)
        .gte('activity_time', startOfDay.toUtc().toIso8601String())
        .lt('activity_time', startOfNextDay.toUtc().toIso8601String())
        .limit(1)
        .maybeSingle();

    if (existingActivity != null) {
      return false;
    }

    // Ambil dan validasi waktu jadwal dari Supabase.
    final rawScheduleTime = schedule['schedule_time']?.toString();

    if (rawScheduleTime == null || rawScheduleTime.isEmpty) {
      throw Exception('Waktu jadwal makan kosong di database.');
    }

    _formatTime(rawScheduleTime);
    // Waktu jadwal tetap divalidasi di atas, tetapi activity_time harus
    // merekam waktu aktual ketika pengguna menekan tombol Sudah Makan.
    // Waktu jadwal dapat ditampilkan terpisah dari relasi meal_schedules.
    await _supabase.from('activity_histories').insert({
      'meal_schedule_id': mealScheduleId,
      'medication_schedule_id': null,
      'status': 'taken',
      'activity_time': now.toUtc().toIso8601String(),
    });

    return true;
  }

  // Mengambil ID jadwal makan yang sudah tercatat hari ini.
  Future<Set<String>> getTodayRecordedMealScheduleIds() async {
    await _requireUserId();

    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    final response = await _supabase
        .from('activity_histories')
        .select('meal_schedule_id')
        .not('meal_schedule_id', 'is', null)
        .gte('activity_time', startOfDay.toUtc().toIso8601String())
        .lt('activity_time', startOfNextDay.toUtc().toIso8601String());

    return response
        .map<String>((item) => item['meal_schedule_id'].toString())
        .toSet();
  }
}
