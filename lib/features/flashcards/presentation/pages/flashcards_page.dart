import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import '../bloc/flashcards_bloc.dart';
import '../bloc/flashcards_event.dart';
import '../bloc/flashcards_state.dart';
import '../widgets/swipeable_card.dart';
import '../widgets/audio_player_button.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/responsive_layout.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FlashcardsBloc>().add(const LoadCategories());
      }
    });
  }

  Brightness _brightness(BuildContext context) {
    return CupertinoTheme.brightnessOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _brightness(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final state = context.read<FlashcardsBloc>().state;
        if (state.selectedCategory != null) {
          context.read<FlashcardsBloc>().add(const DeselectCategory());
        }
      },
      child: CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundFor(brightness),
        child: SafeArea(
          child: BlocBuilder<FlashcardsBloc, FlashcardState>(
            builder: (context, state) {
              if (state.isLoading && state.categories.isEmpty) {
                return const Center(
                  child: CupertinoActivityIndicator(radius: 20),
                );
              }

              if (state.selectedCategory == null) {
                return _buildCategoryList(context, state);
              }

              return _buildCardView(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, FlashcardState state) {
    final isTablet = ResponsiveLayout.isTablet(context);
    final brightness = _brightness(context);

    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          '¡Hola! 👋',
          style: TextStyle(
            fontSize: ResponsiveLayout.titleFontSize(context),
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryFor(brightness),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Elige una categoría',
          style: TextStyle(
            fontSize: ResponsiveLayout.subtitleFontSize(context),
            color: AppColors.textSecondaryFor(brightness),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveLayout.horizontalPadding(context),
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.gridCrossAxisCount(context),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: isTablet ? 1.3 : 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = state.categories[index];
                      return _CategoryCard(
                        categoryId: category.id,
                        name: category.name,
                        icon: category.icon,
                        colorIndex: category.colorIndex,
                        isTablet: isTablet,
                        onTap: () {
                          context.read<FlashcardsBloc>().add(
                                SelectCategory(category.id),
                              );
                        },
                      );
                    },
                    childCount: state.categories.length,
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

  Widget _buildCardView(BuildContext context, FlashcardState state) {
    final card = state.currentCard;
    final brightness = _brightness(context);
    if (card == null) {
      return Center(
        child: Text(
          'No hay tarjetas',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textSecondaryFor(brightness),
          ),
        ),
      );
    }

    final nextCard = (state.cards.length > 1)
        ? (state.hasNext ? state.cards[state.currentIndex + 1] : state.cards[0])
        : null;

    final color = AppColors.categoryColors[
        (state.selectedCategory?.colorIndex ?? 0) % AppColors.categoryColors.length];

    return Column(
      children: [
        const SizedBox(height: 12),
        _buildHeader(context, state, color),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: SwipeableCard(
              key: ValueKey('card_${card.id}_${state.currentIndex}'),
              word: card.word,
              imagePath: card.imagePath,
              nextWord: nextCard?.word,
              nextImagePath: nextCard?.imagePath,
              cardColor: AppColors.cardBackgroundFor(brightness),
              onSwipeLeft: () {
                context.read<FlashcardsBloc>().add(const SwipeNext());
              },
              onSwipeRight: () {
                context.read<FlashcardsBloc>().add(const SwipePrevious());
              },
              onTap: () {
                context.read<FlashcardsBloc>().add(const PlayAudio());
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildNavigationHints(context, state, color),
        const SizedBox(height: 16),
        _buildBackButton(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    FlashcardState state,
    Color color,
  ) {
    final brightness = _brightness(context);
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
            onTap: () {
              context.read<FlashcardsBloc>().add(const DeselectCategory());
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundFor(brightness),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: isDark ? 0.25 : 0.06),
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
                  state.selectedCategory?.icon ?? Iconsax.category,
                  size: 22,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  state.selectedCategory?.name ?? '',
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
            word: state.currentCard?.word ?? '',
            size: ResponsiveLayout.isTablet(context) ? 52 : 44,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationHints(
    BuildContext context,
    FlashcardState state,
    Color color,
  ) {
    final brightness = _brightness(context);
    final isDark = brightness == Brightness.dark;
    final total = state.cards.length;
    final current = state.currentIndex + 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveLayout.horizontalPadding(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          GestureDetector(
            onTap: () {
              context.read<FlashcardsBloc>().add(const SwipePrevious());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundFor(brightness),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.arrow_left_2,
                    size: 16,
                    color: AppColors.textSecondaryFor(brightness),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Anterior',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryFor(brightness),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Counter indicator
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

          // Next button
          GestureDetector(
            onTap: () {
              context.read<FlashcardsBloc>().add(const SwipeNext());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundFor(brightness),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    'Siguiente',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondaryFor(brightness),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Iconsax.arrow_right_2,
                    size: 16,
                    color: AppColors.textSecondaryFor(brightness),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    final brightness = _brightness(context);
    final isDark = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        context.read<FlashcardsBloc>().add(const DeselectCategory());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundFor(brightness),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withValues(alpha: isDark ? 0.2 : 0.06),
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

class _CategoryCard extends StatelessWidget {
  final String categoryId;
  final String name;
  final IconData icon;
  final int colorIndex;
  final bool isTablet;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.colorIndex,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.brightnessOf(context);
    final isDark = brightness == Brightness.dark;
    final color = AppColors.categoryColors[
        colorIndex % AppColors.categoryColors.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.28 : 0.15),
          borderRadius: BorderRadius.circular(isTablet ? 26 : 22),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.45 : 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveLayout.emojiSize(context),
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                fontWeight: FontWeight.w600,
                color: isDark ? CupertinoColors.white : color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
