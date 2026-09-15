import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';

class CardNavigationBar extends StatelessWidget {
  final int current;
  final int total;
  final Color color;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CardNavigationBar({
    super.key,
    required this.current,
    required this.total,
    required this.color,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.horizontalPadding(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: Iconsax.arrow_left_2,
            label: 'Anterior',
            brightness: brightness,
            onTap: onPrevious,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.24 : 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$current / $total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          _NavButton(
            icon: Iconsax.arrow_right_2,
            label: 'Siguiente',
            brightness: brightness,
            iconAfter: true,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Brightness brightness;
  final bool iconAfter;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.brightness,
    this.iconAfter = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;

    final iconWidget = Icon(
      icon,
      size: 16,
      color: AppColors.textSecondaryFor(brightness),
    );
    final textWidget = Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondaryFor(brightness),
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundFor(brightness),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(
                alpha: isDark ? 0.2 : 0.05,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: iconAfter
              ? [textWidget, const SizedBox(width: 4), iconWidget]
              : [iconWidget, const SizedBox(width: 4), textWidget],
        ),
      ),
    );
  }
}