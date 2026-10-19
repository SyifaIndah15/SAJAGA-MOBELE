import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registrasi akun baru
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(email: email.trim(), password: password);
  }

  // Login dengan email dan kata sandi
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  // Mengirim tautan reset kata sandi

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: Uri.base.origin,
    );
  }

  // Menyimpan kata sandi baru untuk pengguna terautentikasi
  Future<UserResponse> updatePassword({required String newPassword}) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
