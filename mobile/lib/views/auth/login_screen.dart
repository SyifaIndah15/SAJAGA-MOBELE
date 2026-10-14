import 'package:flutter/material.dart';
<<<<<<< HEAD
=======

>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
import '../../config/app_constant.dart';
import '../../utils/validator.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
<<<<<<< HEAD
=======
import '../../routes/app_routes.dart';
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
<<<<<<< HEAD
=======
  String? _errorMessage;
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.medical_services_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'SAJAGA',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    'Kelola jadwal konsumsi obat harian Anda',
                    textAlign: TextAlign.center,
<<<<<<< HEAD
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                    ),
=======
                    style: textTheme.bodySmall?.copyWith(color: AppColors.grey),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'E-mail',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _inputDecoration(
                      hintText: 'nama@email.com',
                      prefixIcon: Icons.email_outlined,
                    ),
                    validator: Validator.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Kata Sandi',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
<<<<<<< HEAD
                    decoration: _inputDecoration(
                      hintText: 'Masukkan kata sandi',
                      prefixIcon: Icons.lock_outline,
                    ).copyWith(
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: Validator.validatePassword,
                  ),

=======
                    decoration:
                        _inputDecoration(
                          hintText: 'Masukkan kata sandi',
                          prefixIcon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'Tampilkan kata sandi'
                                : 'Sembunyikan kata sandi',
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                    validator: Validator.validatePassword,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
<<<<<<< HEAD
=======

>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                      child: Text(
                        'Lupa Kata Sandi?',
                        style: textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: () {
<<<<<<< HEAD
                      if (_formKey.currentState!.validate()) {
                        // TODO: Hubungkan ke proses login Supabase.
=======
                      print("TOMBOL LOGIN DITEKAN");
                      if (!_formKey.currentState!.validate()) {
                        print("VALIDASI GAGAL");
                        return;
                      }
                      print("VALIDASI BERHASIL");
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      print(email);
                      print(password);
                      if (email == "test@sajaga.com" &&
                          password == "12345678") {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      } else {
                        print("LOGIN GAGAL");
                        setState(() {
                          _errorMessage = "Email atau kata sandi tidak sesuai";
                        });
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Masuk →',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Belum punya akun? ',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Daftar sekarang',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.grey.withValues(alpha: 0.8),
        fontSize: 13,
      ),
<<<<<<< HEAD
      prefixIcon: Icon(
        prefixIcon,
        size: 20,
        color: AppColors.grey,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
=======
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.grey),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
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
<<<<<<< HEAD
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
=======
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
<<<<<<< HEAD
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }
}
=======
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
