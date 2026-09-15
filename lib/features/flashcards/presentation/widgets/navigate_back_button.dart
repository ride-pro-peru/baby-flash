import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';

class NavigateBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const NavigateBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundFor(brightness),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(
                alpha: isDark ? 0.2 : 0.06,
              ),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          'Volver a categorías',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimaryFor(brightness),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}