import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryContrastingColor: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: Color(0xF0F9F9FF),
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.primary,
        textStyle: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      primaryContrastingColor: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      barBackgroundColor: Color(0xFF1E1E32),
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.primary,
        textStyle: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 16,
          color: AppColors.darkTextPrimary,
        ),
        navLargeTitleTextStyle: TextStyle(
          fontFamily: '.SF Pro Display',
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        navTitleTextStyle: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
