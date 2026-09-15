import 'package:equatable/equatable.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/category_entity.dart';

class FlashcardState extends Equatable {
  final List<CategoryEntity> categories;
  final CategoryEntity? selectedCategory;
  final List<FlashcardEntity> cards;
  final int currentIndex;
  final bool isLoading;
  final bool isPlayingAudio;
  final String? errorMessage;
  final Map<String, String> customCardImages;

  const FlashcardState({
    this.categories = const [],
    this.selectedCategory,
    this.cards = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.isPlayingAudio = false,
    this.errorMessage,
    this.customCardImages = const {},
  });

  FlashcardEntity? get currentCard {
    if (cards.isEmpty || currentIndex >= cards.length) return null;
    return cards[currentIndex];
  }

  bool get hasPrevious => currentIndex > 0;
  bool get hasNext => currentIndex < cards.length;

  int get totalSlots => cards.length + 1;

  String? customImagePathFor(String cardId) => customCardImages[cardId];

  FlashcardState copyWith({
    List<CategoryEntity>? categories,
    CategoryEntity? selectedCategory,
    List<FlashcardEntity>? cards,
    int? currentIndex,
    bool? isLoading,
    bool? isPlayingAudio,
    String? errorMessage,
    Map<String, String>? customCardImages,
    bool clearSelectedCategory = false,
  }) {
    return FlashcardState(
      categories: categories ?? this.categories,
      selectedCategory: clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      isPlayingAudio: isPlayingAudio ?? this.isPlayingAudio,
      errorMessage: errorMessage,
      customCardImages: customCardImages ?? this.customCardImages,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        selectedCategory,
        cards,
        currentIndex,
        isLoading,
        isPlayingAudio,
        errorMessage,
        customCardImages,
      ];
}
