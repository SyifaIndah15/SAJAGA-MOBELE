import 'package:flutter/material.dart';

// Import kelima screen menggunakan path relatif
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/reset_password_screen.dart';
import 'views/auth/email_verification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAJAGA',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/email-verification': (context) => const EmailVerificationScreen(),
      },
    );
  }
}