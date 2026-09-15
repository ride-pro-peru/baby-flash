import 'package:flutter/cupertino.dart';

class ResponsiveLayout {
  ResponsiveLayout._();

  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1024) return 4;
    if (width >= 768) return 3;
    return 2;
  }

  static double cardWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width >= 1024) return width * 0.5;
    if (width >= 768) return width * 0.6;
    return width * 0.85;
  }

  static double cardHeight(BuildContext context) {
    final height = screenHeight(context);
    if (height >= 1024) return height * 0.55;
    if (height >= 768) return height * 0.6;
    return height * 0.65;
  }

  static double emojiSize(BuildContext context) {
    return isTablet(context) ? 48 : 36;
  }

  static double wordFontSize(BuildContext context) {
    return isTablet(context) ? 48 : 36;
  }

  static double titleFontSize(BuildContext context) {
    return isTablet(context) ? 42 : 32;
  }

  static double subtitleFontSize(BuildContext context) {
    return isTablet(context) ? 24 : 20;
  }

  static double horizontalPadding(BuildContext context) {
    return isTablet(context) ? 32 : 16;
  }
}
