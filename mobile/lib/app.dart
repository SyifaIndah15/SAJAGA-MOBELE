
import 'package:flutter/material.dart';

import 'config/app_theme.dart';

class SajagaApp extends StatelessWidget {
  const SajagaApp({
    super.key,
    required this.home,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAJAGA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: home,
    );
  }
}
