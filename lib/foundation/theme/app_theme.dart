import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.green,
      secondary: AppColors.amber,
      error: AppColors.rose,
      surface: AppColors.bgCard,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dividerColor: AppColors.border,
    fontFamily: 'Inter',
  );
}
