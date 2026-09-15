import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';

class AddCardPlaceholder extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;

  const AddCardPlaceholder({
    super.key,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final cardWidth = ResponsiveLayout.cardWidth(context);
    final cardHeight = ResponsiveLayout.cardHeight(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundFor(brightness),
          borderRadius: BorderRadius.circular(isTablet ? 36 : 28),
          border: Border.all(
            width: 3,
            color: borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(
                alpha: brightness == Brightness.dark ? 0.3 : 0.08,
              ),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.add_circle,
              size: isTablet ? 72 : 56,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nueva tarjeta',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryFor(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}