import 'package:flutter/material.dart';
<<<<<<< HEAD
=======

>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
import '../../config/app_constant.dart';
import '../../utils/validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
=======
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
<<<<<<< HEAD
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.navy,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Security Verification',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.grey,
          ),
=======
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Atur Ulang Kata Sandi',
          style: textTheme.titleSmall?.copyWith(color: AppColors.grey),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
<<<<<<< HEAD
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
=======
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Buat Kata Sandi Baru',
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
<<<<<<< HEAD
                  'Kata sandi baru Anda harus berbeda dari kata '
                  'sandi yang pernah digunakan sebelumnya.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
=======
                  'Buat kata sandi baru untuk mengamankan kembali '
                  'akun SAJAGA Anda.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                ),
                const SizedBox(height: 24),

                Text(
                  'Kata Sandi Baru',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscure1,
                  decoration: _inputDecoration(
                    hintText: 'Masukkan kata sandi baru',
                    suffixIcon: IconButton(
                      tooltip: _obscure1
                          ? 'Tampilkan kata sandi'
                          : 'Sembunyikan kata sandi',
                      icon: Icon(
                        _obscure1
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure1 = !_obscure1;
                        });
                      },
                    ),
                  ),
                  validator: Validator.validatePassword,
                ),
                const SizedBox(height: 16),

                Text(
                  'Konfirmasi Kata Sandi',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscure2,
                  decoration: _inputDecoration(
                    hintText: 'Ulangi kata sandi baru',
                    suffixIcon: IconButton(
                      tooltip: _obscure2
                          ? 'Tampilkan kata sandi'
                          : 'Sembunyikan kata sandi',
                      icon: Icon(
                        _obscure2
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscure2 = !_obscure2;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    return Validator.validateConfirmPassword(
                      value,
                      _newPasswordController.text,
                    );
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Hubungkan ke proses perubahan
                      // kata sandi melalui Supabase Auth.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
<<<<<<< HEAD
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
=======
                    padding: const EdgeInsets.symmetric(vertical: 16),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan Kata Sandi →',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required Widget suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
<<<<<<< HEAD
      hintStyle: TextStyle(
        color: AppColors.grey,
        fontSize: 13,
      ),
=======
      hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
      prefixIcon: const Icon(
        Icons.lock_outline,
        size: 20,
        color: AppColors.grey,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
<<<<<<< HEAD
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.lightBlue,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.lightBlue,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}
=======
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
