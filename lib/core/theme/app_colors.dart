import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Light
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color background = Color(0xFFF5F5FF);
  static const Color cardBackground = CupertinoColors.white;
  static const Color cardImageBackground = Color(0xFFF4F4FA);
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7394);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  // Dark
  static const Color darkBackground = Color(0xFF13131A);
  static const Color darkCardBackground = Color(0xFF252836);
  static const Color darkCardImageBackground = Color(0xFF2E2E44);
  static const Color darkTextPrimary = Color(0xFFF0F0FF);
  static const Color darkTextSecondary = Color(0xFF9A9DB5);

  static const List<Color> categoryColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFFFFA07A),
    Color(0xFF98D8C8),
    Color(0xFFF7DC6F),
    Color(0xFFBB8FCE),
    Color(0xFF85C1E9),
    Color(0xFFF1948A),
    Color(0xFF82E0AA),
    Color(0xFFF0B27A),
    Color(0xFFAED6F1),
    Color(0xFF9B59B6),
  ];

  static Color backgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : background;

  static Color cardBackgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkCardBackground : cardBackground;

  static Color cardImageBackgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkCardImageBackground : cardImageBackground;

  static Color textPrimaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextPrimary : textPrimary;

  static Color textSecondaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkTextSecondary : textSecondary;
}
