import 'package:flutter/material.dart';
import 'app_constant.dart';


class AppTheme {


static ThemeData theme = ThemeData(

  scaffoldBackgroundColor:
      AppColors.background,


  primaryColor:
      AppColors.primary,


  fontFamily: "Poppins",


  colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary
  ),


  appBarTheme: const AppBarTheme(

    backgroundColor:
        Colors.white,

    elevation: 0,

    iconTheme:
        IconThemeData(
          color: AppColors.navy
        ),

    titleTextStyle:
        TextStyle(

          color: AppColors.navy,

          fontSize: 18,

          fontWeight:
          FontWeight.bold,

        ),

  ),


);

}