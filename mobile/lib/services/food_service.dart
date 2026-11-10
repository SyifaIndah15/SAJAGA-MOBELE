import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getFoods() async {
    final response = await _supabase.from('foods').select();

    return List<Map<String, dynamic>>.from(response);
  }
}
