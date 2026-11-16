
import 'package:supabase_flutter/supabase_flutter.dart';

class MealService {
  MealService({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  String _formatTime(String time) {
    final normalized = time.replaceAll('.', ':');
    final parts = normalized.split(':');

    if (parts.length < 2) {
      throw Exception('Format waktu makan tidak valid.');
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      throw Exception('Waktu makan tidak valid.');
    }

    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}:00';
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
        .select(
          'id, user_id, meal_type, schedule_time, is_active',
        )
        .eq('user_id', userId)
        .order('schedule_time');

    return response
        .map<Map<String, dynamic>>(
          (item) => Map<String, dynamic>.from(item),
        )
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
      await _supabase
          .from('meal_schedules')
          .insert(data);
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
}
