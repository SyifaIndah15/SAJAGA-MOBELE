
import 'package:flutter/material.dart';

import 'config/app_theme.dart';
import 'views/home/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    ),
  );
}
