import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAJAGA',
      debugShowCheckedModeBanner: false,

      // Halaman pertama saat aplikasi dibuka
      initialRoute: AppRoutes.login,

      // Daftar navigasi aplikasi
      routes: AppRoutes.routes,
    );
  }
}
