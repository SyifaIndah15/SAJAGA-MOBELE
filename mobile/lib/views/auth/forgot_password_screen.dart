import 'package:flutter/material.dart';
<<<<<<< HEAD
=======

>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
import '../../config/app_constant.dart';
import '../../utils/validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
<<<<<<< HEAD
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
=======
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
=======
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Minimalist healthcare app SAJAGA',
<<<<<<< HEAD
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.grey,
          ),
=======
          style: textTheme.labelMedium?.copyWith(color: AppColors.grey),
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
                  'BANTUAN AKSES AKUN',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
<<<<<<< HEAD
                  'Pemulihan Kata Sandi',
=======
                  'Atur Ulang Kata Sandi',
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
<<<<<<< HEAD
                  'Masukkan alamat e-mail terdaftar pada akun SAJAGA Anda. '
                  'Kami akan memverifikasi dan mengirimkan tautan aman '
                  'untuk mengatur ulang kata sandi.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
=======
                  'Masukkan alamat e-mail yang terdaftar pada akun SAJAGA Anda. '
                  'Kami akan mengirimkan tautan aman untuk membuat kata sandi baru '
                  'setelah proses verifikasi berhasil.',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                ),
                const SizedBox(height: 24),

                Text(
                  'Alamat E-mail Terdaftar',
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

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.security,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
<<<<<<< HEAD
                          'Keamanan Terverifikasi: Pastikan email aktif '
                          'dan sesuai dengan yang didaftarkan saat '
                          'registrasi akun pemeliharaan medis Anda.',
=======
                          'Keamanan Akun: Pastikan email yang dimasukkan aktif '
                          'dan sesuai dengan email yang digunakan saat registrasi '
                          'akun SAJAGA Anda.',
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
<<<<<<< HEAD
                      // TODO: Hubungkan ke proses pemulihan
                      // kata sandi melalui Supabase Auth.
=======
                      // TODO: Hubungkan ke proses reset password
                      // melalui Supabase Auth.
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
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
<<<<<<< HEAD
                    'Verifikasi & Kirim Tautan →',
=======
                    'Kirim Tautan Reset →',
>>>>>>> 78590bf460589008138e9989aa42c9b04566bedb
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Divider(color: AppColors.lightBlue),
                const SizedBox(height: 8),

                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Arahkan ke LoginScreen.
                    },
                    child: Text(
                      'Ingat kata sandi? Masuk Sekarang',
                      textAlign: TextAlign.center,
                      style: textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed: () {
                      // TODO: Hubungkan ke halaman bantuan.
                    },
                    child: Text(
                      'Butuh bantuan lain? Hubungi Bantuan SAJAGA',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
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
    required IconData prefixIcon,
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
        Icons.email_outlined,
        size: 20,
        color: AppColors.grey,
      ),
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
