import 'package:flutter/material.dart';

import '../views/auth/login_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/auth/reset_password_screen.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    profile: (context) => const ProfileScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
  };
}
