import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_constant.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  bool get _hasMinimumLength => _newPasswordController.text.length >= 8;
  bool get _hasLettersAndNumbers =>
      RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(_newPasswordController.text);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi';
    if (value.length < 8) return 'Kata sandi minimal 8 karakter';
    if (!RegExp(r'(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
      return 'Gunakan kombinasi huruf dan angka';
    }
    return null;
  }

  Future<void> _saveNewPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _authService.updatePassword(
        newPassword: _newPasswordController.text,
      );

      // Akhiri sesi recovery agar pengguna benar-benar masuk kembali
      // menggunakan password baru dari halaman Login.
      try {
        await _authService.signOut();
      } catch (_) {
        // Password sudah berhasil diperbarui; kegagalan sign-out tidak
        // boleh mengubah status pembaruan password menjadi gagal.
      }

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.resetPasswordSuccess,
        (route) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui kata sandi. Periksa koneksi lalu coba lagi.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.navy),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SAJAGA',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Security Verification',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person_rounded, color: AppColors.white, size: 17),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 4),
                    const _ResetIllustration(),
                    const SizedBox(height: 22),
                    Text(
                      'Buat Kata Sandi Baru',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kata sandi baru Anda harus berbeda dari kata sandi '
                      'yang pernah digunakan sebelumnya.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A0F172A),
                            blurRadius: 22,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kata Sandi Baru',
                                style: textTheme.labelMedium?.copyWith(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              _statusPill(
                                _hasMinimumLength && _hasLettersAndNumbers
                                    ? 'Memenuhi'
                                    : 'Belum Diisi',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            onChanged: (_) => setState(() {}),
                            validator: _validateNewPassword,
                            decoration: _passwordDecoration(
                              hint: 'Masukkan kata sandi baru',
                              visible: !_obscurePassword,
                              onToggle: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _passwordRule('Minimal 8 karakter', _hasMinimumLength),
                          const SizedBox(height: 5),
                          _passwordRule(
                            'Kombinasi huruf & angka',
                            _hasLettersAndNumbers,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Konfirmasi Kata Sandi',
                            style: textTheme.labelMedium?.copyWith(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmation,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi kata sandi wajib diisi';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Kata sandi belum sama';
                              }
                              return null;
                            },
                            decoration: _passwordDecoration(
                              hint: 'Ulangi kata sandi baru',
                              visible: !_obscureConfirmation,
                              onToggle: () => setState(
                                () => _obscureConfirmation = !_obscureConfirmation,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _saveNewPassword,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 17,
                                      height: 17,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Icon(Icons.arrow_forward_rounded, size: 18),
                              label: Text(
                                _isLoading ? 'Menyimpan...' : 'Simpan Kata Sandi',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: const Color(0xFF9CC6D8),
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🛡 Terenkripsi & Terlindungi SAJAGA Health',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetIllustration extends StatelessWidget {
  const _ResetIllustration();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 82,
          height: 82,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF4FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),
          ),
        ),
      );
}

Widget _statusPill(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.grey,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

Widget _passwordRule(String label, bool passed) => Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 13,
          color: passed ? Colors.green : AppColors.grey,
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.grey),
        ),
      ],
    );

InputDecoration _passwordDecoration({
  required String hint,
  required bool visible,
  required VoidCallback onToggle,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
    prefixIcon: const Icon(
      Icons.lock_outline_rounded,
      size: 18,
      color: AppColors.grey,
    ),
    suffixIcon: IconButton(
      tooltip: visible ? 'Sembunyikan kata sandi' : 'Tampilkan kata sandi',
      onPressed: onToggle,
      icon: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 18,
        color: AppColors.grey,
      ),
    ),
    filled: true,
    fillColor: const Color(0xFFF3F5FF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
    ),
  );
}
