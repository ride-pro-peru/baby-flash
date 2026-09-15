import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Light
  static const Color primary = Color(0xFF7C71F5);
  static const Color secondary = Color(0xFFFF7A90);
  static const Color background = Color(0xFFFBF8F3); // Warm pastel cream
  static const Color cardBackground = CupertinoColors.white;
  static const Color cardImageBackground = Color(0xFFF8F5EF);
  static const Color textPrimary = Color(0xFF2C3140);
  static const Color textSecondary = Color(0xFF757D94);
  static const Color success = Color(0xFF5AC27E);
  static const Color warning = Color(0xFFFFB834);

  // Dark
  static const Color darkBackground = Color(0xFF181A22);
  static const Color darkCardBackground = Color(0xFF232734);
  static const Color darkCardImageBackground = Color(0xFF2D3244);
  static const Color darkTextPrimary = Color(0xFFF5F6FA);
  static const Color darkTextSecondary = Color(0xFFA2A8BD);

  // Pastel Category Palettes
  static const List<Color> categoryColors = [
    Color(0xFFE06D53), // 0: Animales
    Color(0xFFE55B77), // 1: Frutas
    Color(0xFF7B62BA), // 2: Colores
    Color(0xFF388ECC), // 3: Vehículos
    Color(0xFFC4891C), // 4: Cuerpo
    Color(0xFF359B65), // 5: Hogar
    Color(0xFFB8538A), // 6: Ropa
    Color(0xFFCC6E37), // 7: Familia
    Color(0xFFB29312), // 8: Emociones
    Color(0xFF30996F), // 9: Comida
    Color(0xFF42A34F), // 10: Naturaleza
    Color(0xFF2393A5), // 11: Números
    Color(0xFF5B67C5), // 12: Mix
  ];

  static const List<Color> pastelCategoryBackgrounds = [
    Color(0xFFFFEAE0), // 0: Animales
    Color(0xFFFFE4E9), // 1: Frutas
    Color(0xFFEDE6FA), // 2: Colores
    Color(0xFFE2F2FF), // 3: Vehículos
    Color(0xFFFFF4D4), // 4: Cuerpo
    Color(0xFFE0F7EB), // 5: Hogar
    Color(0xFFFAE4F0), // 6: Ropa
    Color(0xFFFFEBDD), // 7: Familia
    Color(0xFFFFF9CF), // 8: Emociones
    Color(0xFFE2F7EF), // 9: Comida
    Color(0xFFE2F8E3), // 10: Naturaleza
    Color(0xFFDFF6F9), // 11: Números
    Color(0xFFEAEBFE), // 12: Mix
  ];

  static Color categoryPastelBg(int index, Brightness brightness) {
    if (brightness == Brightness.dark) {
      return darkCardBackground;
    }
    return pastelCategoryBackgrounds[index % pastelCategoryBackgrounds.length];
  }

  static Color categoryAccent(int index, Brightness brightness) {
    return categoryColors[index % categoryColors.length];
  }

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
