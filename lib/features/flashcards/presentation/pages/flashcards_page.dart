import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/flashcards_bloc.dart';
import '../bloc/flashcards_event.dart';
import '../bloc/flashcards_state.dart';
import '../widgets/add_card_placeholder.dart';
import '../widgets/card_header.dart';
import '../widgets/card_navigation_bar.dart';
import '../widgets/category_grid.dart';
import '../widgets/change_photo_button.dart';
import '../widgets/create_card_sheet.dart';
import '../widgets/navigate_back_button.dart';
import '../widgets/swipeable_card.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../../../core/theme/app_colors.dart';

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

  void _selectCategory(String categoryId) {
    context.read<FlashcardsBloc>().add(SelectCategory(categoryId));
  }

  void _deselectCategory() {
    context.read<FlashcardsBloc>().add(const DeselectCategory());
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
          _deselectCategory();
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
                return CategoryGrid(
                  categories: state.categories,
                  customCategoryImages: state.customCardImages,
                  onCategoryTap: _selectCategory,
                  onCategoryChangeImage: (catId) =>
                      _pickAndSetCategoryIcon(context, catId),
                );
              }

              return _buildCardView(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardView(BuildContext context, FlashcardState state) {
    final isAddCard = state.currentIndex >= state.cards.length;
    final card = state.currentCard;
    final brightness = _brightness(context);
    final category = state.selectedCategory!;

    final color = AppColors.categoryColors[
        category.colorIndex % AppColors.categoryColors.length];

    return Column(
      children: [
        const SizedBox(height: 12),
        CardHeader(
          categoryName: category.name,
          categoryIcon: category.icon,
          color: color,
          word: card?.word ?? '',
          onBack: _deselectCategory,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Center(
            child: isAddCard
                ? AddCardPlaceholder(
                    borderColor: color.withValues(alpha: 0.5),
                    onTap: () => _openCreateCardSheet(context, state),
                  )
                : (card == null
                    ? Text(
                        'No hay tarjetas',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondaryFor(brightness),
                        ),
                      )
                    : _buildSwipeableCard(context, state, card)),
          ),
        ),
        const SizedBox(height: 12),
        if (!isAddCard)
          ChangePhotoButton(
            onTap: () => _pickAndSetImage(context, card!.id),
          ),
        const SizedBox(height: 12),
        CardNavigationBar(
          current: state.currentIndex + 1,
          total: state.totalSlots,
          color: color,
          onPrevious: () => context.read<FlashcardsBloc>().add(
                const SwipePrevious(),
              ),
          onNext: () => context.read<FlashcardsBloc>().add(
                const SwipeNext(),
              ),
        ),
        const SizedBox(height: 16),
        NavigateBackButton(onTap: _deselectCategory),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSwipeableCard(
    BuildContext context,
    FlashcardState state,
    FlashcardEntity card,
  ) {
    final brightness = _brightness(context);
    final nextCard = (state.currentIndex + 1 < state.cards.length)
        ? state.cards[state.currentIndex + 1]
        : null;

    return SwipeableCard(
      key: ValueKey('card_${card.id}_${state.currentIndex}'),
      word: card.word,
      imagePath: card.imagePath,
      customImagePath: state.customImagePathFor(card.id),
      nextWord: nextCard?.word,
      nextImagePath: nextCard?.imagePath,
      nextCustomImagePath: nextCard == null
          ? null
          : state.customImagePathFor(nextCard.id),
      cardColor: AppColors.cardBackgroundFor(brightness),
      onSwipeLeft: () => context.read<FlashcardsBloc>().add(
            const SwipeNext(),
          ),
      onSwipeRight: () => context.read<FlashcardsBloc>().add(
            const SwipePrevious(),
          ),
      onTap: () => context.read<FlashcardsBloc>().add(
            const PlayAudio(),
          ),
    );
  }

  Future<void> _openCreateCardSheet(
    BuildContext context,
    FlashcardState state,
  ) async {
    final category = state.selectedCategory;
    if (category == null) return;
    await Navigator.of(context).push(
      CupertinoPageRoute<void>(
        builder: (_) => CreateCardSheet(
          categoryName: category.name,
          onSave: (word, image) {
            context.read<FlashcardsBloc>().add(
                  CreateCustomCard(
                    word: word,
                    categoryId: category.id,
                    image: image,
                  ),
                );
          },
        ),
      ),
    );
  }

  Future<void> _pickAndSetImage(BuildContext context, String cardId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 88,
    );
    if (picked == null) return;
    if (!context.mounted) return;
    context.read<FlashcardsBloc>().add(
          SetCardImage(cardId: cardId, image: File(picked.path)),
        );
  }

  Future<void> _pickAndSetCategoryIcon(
    BuildContext context,
    String categoryId,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 88,
    );
    if (picked == null) return;
    if (!context.mounted) return;
    context.read<FlashcardsBloc>().add(
          SetCardImage(cardId: 'cat_$categoryId', image: File(picked.path)),
        );
  }
}