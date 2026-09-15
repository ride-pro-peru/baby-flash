import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';
import 'audio_player_button.dart';

class CardHeader extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color color;
  final String word;
  final VoidCallback onBack;

  const CardHeader({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.color,
    required this.word,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.horizontalPadding(context),
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundFor(brightness),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(
                      alpha: isDark ? 0.25 : 0.06,
                    ),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                Iconsax.arrow_left,
                size: 22,
                color: AppColors.textPrimaryFor(brightness),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.28 : 0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Icon(
                  categoryIcon,
                  size: 22,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: ResponsiveLayout.isTablet(context) ? 20 : 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          AudioPlayerButton(
            word: word,
            size: ResponsiveLayout.isTablet(context) ? 52 : 44,
          ),
        ],
      ),
    );
  }
}