import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';
import '../../domain/entities/category_entity.dart';

class CategoryGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<String> onCategoryTap;
  final Map<String, String> customCategoryImages;
  final ValueChanged<String>? onCategoryChangeImage;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.customCategoryImages = const {},
    this.onCategoryChangeImage,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          '¡Hola! 👋',
          style: GoogleFonts.fredoka(
            fontSize: ResponsiveLayout.titleFontSize(context),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.textPrimaryFor(brightness),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF242836) : const Color(0xFFF2ECE1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('✨', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Text(
                'Elige una categoría',
                style: GoogleFonts.fredoka(
                  fontSize: ResponsiveLayout.subtitleFontSize(context) * 0.75,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondaryFor(brightness),
                ),
              ),
              const SizedBox(width: 6),
              const Text('✨', style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveLayout.horizontalPadding(context),
                  vertical: 4,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.gridCrossAxisCount(context),
                    mainAxisSpacing: isTablet ? 18 : 14,
                    crossAxisSpacing: isTablet ? 18 : 14,
                    childAspectRatio: 1.0, // Formato cuadrado
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = categories[index];
                      final customImgPath =
                          customCategoryImages['cat_${category.id}'];
                      return _CategoryCard(
                        name: category.name,
                        icon: category.icon,
                        customImagePath: customImgPath,
                        colorIndex: category.colorIndex,
                        isTablet: isTablet,
                        onTap: () => onCategoryTap(category.id),
                        onChangeImage: onCategoryChangeImage == null
                            ? null
                            : () => onCategoryChangeImage!(category.id),
                      );
                    },
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final String? customImagePath;
  final int colorIndex;
  final bool isTablet;
  final VoidCallback onTap;
  final VoidCallback? onChangeImage;

  const _CategoryCard({
    required this.name,
    required this.icon,
    this.customImagePath,
    required this.colorIndex,
    required this.isTablet,
    required this.onTap,
    this.onChangeImage,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final accentColor = AppColors.categoryAccent(widget.colorIndex, brightness);
    final bgColor = AppColors.categoryPastelBg(widget.colorIndex, brightness);
    final hasCustomImage = widget.customImagePath != null &&
        File(widget.customImagePath!).existsSync();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: widget.onChangeImage,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(widget.isTablet ? 36 : 30),
            boxShadow: isDark
                ? [
                    BoxShadow(
                      color: CupertinoColors.black.withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                      spreadRadius: -2,
                    ),
                    const BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: widget.isTablet ? 16 : 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasCustomImage)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            widget.isTablet ? 22 : 18,
                          ),
                          child: Image.file(
                            File(widget.customImagePath!),
                            width: widget.isTablet ? 64 : 52,
                            height: widget.isTablet ? 64 : 52,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Icon(
                          widget.icon,
                          size: widget.isTablet ? 56 : 48,
                          color: accentColor,
                        ),
                      SizedBox(height: widget.isTablet ? 10 : 8),
                      Text(
                        widget.name,
                        style: GoogleFonts.fredoka(
                          fontSize: widget.isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkTextPrimary : accentColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.onChangeImage != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onChangeImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? CupertinoColors.white.withValues(alpha: 0.16)
                            : CupertinoColors.white.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.camera_fill,
                        size: widget.isTablet ? 16 : 13,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}