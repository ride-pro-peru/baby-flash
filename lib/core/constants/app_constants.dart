class AppConstants {
  AppConstants._();

  static const String appName = 'BabyFlash';
  static const double swipeThreshold = 0.15; // 15% instead of 30% for effortless swipe
  static const double minFlingVelocity = 350.0; // Quick flick gesture detection
  static const Duration animationDuration = Duration(milliseconds: 220);
  static const Duration autoPlayDelay = Duration(seconds: 5);
}
