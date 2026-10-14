import 'package:flutter/material.dart';

import '../views/auth/login_screen.dart';
import '../views/home/home_screen.dart';
import '../views/profile/profile_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    profile: (context) => const ProfileScreen(),
  };
}