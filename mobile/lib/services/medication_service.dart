import 'package:supabase_flutter/supabase_flutter.dart';

class MedicationService {
  MedicationService({SupabaseClient? client})
    : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<List<Map<String, dynamic>>> getTodaySchedules() async {
    // Memeriksa pengguna yang sedang login.
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    // 1. Mengambil obat berdasarkan user_id.
    final medications = await _supabase
        .from('medications')
        .select('id, name, dose, days')
        .eq('user_id', user.id);

    if (medications.isEmpty) {
      return [];
    }

    // 2. Mengambil ID obat.
    final List<String> medicationIds = medications
        .map<String>((item) => item['id'].toString())
        .toList();

    // 3. Mengambil jadwal aktif berdasarkan medication_id.
    final schedules = await _supabase
        .from('medication_schedules')
        .select('id, medication_id, schedule_time, meal_instruction, is_active')
        .inFilter('medication_id', medicationIds)
        .eq('is_active', true);

    // 4. Membuat pemetaan obat berdasarkan ID.
    final Map<String, Map<String, dynamic>> medicationMap = {
      for (final medication in medications)
        medication['id'].toString(): Map<String, dynamic>.from(medication),
    };

    final List<Map<String, dynamic>> result = [];

    // 5. Menggabungkan data obat dengan jadwal.
    for (final schedule in schedules) {
      final medication = medicationMap[schedule['medication_id'].toString()];

      if (medication == null) continue;

      result.add({
        ...Map<String, dynamic>.from(schedule),
        'medication_name': medication['name'],
        'medication_dose': medication['dose'],
        'medication_days': medication['days'],
      });
    }

    // 6. Mengurutkan berdasarkan waktu minum.
    result.sort((a, b) {
      return a['schedule_time'].toString().compareTo(
        b['schedule_time'].toString(),
      );
    });

    return result;
  }
}
