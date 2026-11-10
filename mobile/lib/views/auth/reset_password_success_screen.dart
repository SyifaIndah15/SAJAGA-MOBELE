import 'package:flutter/material.dart';

import '../../config/app_constant.dart';
import '../../routes/app_routes.dart';

class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

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
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          ),
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const _SuccessIllustration(),
                  const SizedBox(height: 28),
                  Text(
                    'Kata Sandi Berhasil Disimpan!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kata sandi Anda berhasil diperbarui. Silakan masuk '
                    'kembali dengan kata sandi baru Anda.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.grey,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 34),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      ),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Masuk Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kanal Bantuan SAJAGA belum dikonfigurasi.'),
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                            height: 1.5,
                          ),
                          children: const [
                            TextSpan(text: 'Mengalami kendala saat masuk?\n'),
                            TextSpan(
                              text: 'Hubungi Bantuan SAJAGA',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
    );
  }
}

class _SuccessIllustration extends StatelessWidget {
  const _SuccessIllustration();

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 104,
          height: 104,
          decoration: const BoxDecoration(
            color: Color(0xFFEAF4FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ),
        ),
      );
}
