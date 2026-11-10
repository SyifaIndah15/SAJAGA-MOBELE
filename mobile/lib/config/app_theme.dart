import 'package:flutter/material.dart';
import 'app_constant.dart';

class AppTheme {

  static ThemeData theme = ThemeData(

    scaffoldBackgroundColor:
        AppColors.background,

    primaryColor:
        AppColors.primary,

    fontFamily: "PlusJakartaSans",

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.white,
    ),

    appBarTheme: const AppBarTheme(

      backgroundColor:
          AppColors.white,

      elevation: 0,

      iconTheme: IconThemeData(
        color: AppColors.navy,
      ),

      titleTextStyle: TextStyle(
        color: AppColors.navy,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}