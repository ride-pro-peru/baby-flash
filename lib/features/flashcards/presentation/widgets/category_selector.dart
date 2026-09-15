import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';

class CategorySelector extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String? selectedId;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    this.selectedId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);

    return SizedBox(
      height: isTablet ? 130 : 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.horizontalPadding(context),
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category['id'] == selectedId;
          final colorIndex = category['colorIndex'] as int;
          final color = AppColors.categoryColors[
              colorIndex % AppColors.categoryColors.length];

          return GestureDetector(
            onTap: () => onCategorySelected(category['id'] as String),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 22 : 16,
                vertical: isTablet ? 16 : 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(isTablet ? 26 : 20),
                border: Border.all(
                  color: isSelected ? color : CupertinoColors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category['emoji'] as String,
                    style: TextStyle(
                      fontSize: ResponsiveLayout.emojiSize(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? CupertinoColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}