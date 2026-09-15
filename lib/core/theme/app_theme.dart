import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static CupertinoThemeData get lightTheme {
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      primaryContrastingColor: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: const Color(0xF0FAF8F3),
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.primary,
        textStyle: GoogleFonts.fredoka(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        navLargeTitleTextStyle: GoogleFonts.fredoka(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        navTitleTextStyle: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      primaryContrastingColor: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      barBackgroundColor: const Color(0xF01E212D),
      textTheme: CupertinoTextThemeData(
        primaryColor: AppColors.primary,
        textStyle: GoogleFonts.fredoka(
          fontSize: 16,
          color: AppColors.darkTextPrimary,
        ),
        navLargeTitleTextStyle: GoogleFonts.fredoka(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
        navTitleTextStyle: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
