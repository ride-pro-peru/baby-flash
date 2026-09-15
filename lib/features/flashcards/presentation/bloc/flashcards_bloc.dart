import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/flashcards_repository.dart';
import 'flashcards_event.dart';
import 'flashcards_state.dart';

class FlashcardsBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final FlashcardsRepository repository;

  FlashcardsBloc({required this.repository}) : super(const FlashcardState()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
    on<SwipeNext>(_onSwipeNext);
    on<SwipePrevious>(_onSwipePrevious);
    on<DeselectCategory>(_onDeselectCategory);
    on<SetCardImage>(_onSetCardImage);
    on<CreateCustomCard>(_onCreateCustomCard);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await repository.getCategories();
      final customImages = await repository.getAllCustomImages();
      emit(state.copyWith(
        categories: categories,
        customCardImages: customImages,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final cards = await repository.getCardsByCategory(event.categoryId);
      final category = state.categories.firstWhere(
        (c) => c.id == event.categoryId,
      );
      emit(state.copyWith(
        selectedCategory: category,
        cards: cards,
        currentIndex: 0,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSwipeNext(
    SwipeNext event,
    Emitter<FlashcardState> emit,
  ) {
    if (state.currentIndex < state.cards.length) {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
      ));
    } else {
      emit(state.copyWith(
        currentIndex: 0,
      ));
    }
  }

  void _onSwipePrevious(
    SwipePrevious event,
    Emitter<FlashcardState> emit,
  ) {
    if (state.currentIndex > 0) {
      emit(state.copyWith(
        currentIndex: state.currentIndex - 1,
      ));
    } else {
      emit(state.copyWith(
        currentIndex: state.cards.length,
      ));
    }
  }

  void _onDeselectCategory(
    DeselectCategory event,
    Emitter<FlashcardState> emit,
  ) {
    emit(state.copyWith(
      clearSelectedCategory: true,
      cards: const [],
      currentIndex: 0,
    ));
  }

  Future<void> _onSetCardImage(
    SetCardImage event,
    Emitter<FlashcardState> emit,
  ) async {
    try {
      final savedPath = await repository.saveCardImage(event.cardId, event.image);
      final customImages = Map<String, String>.from(state.customCardImages)
        ..[event.cardId] = savedPath;
      emit(state.copyWith(customCardImages: customImages));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateCustomCard(
    CreateCustomCard event,
    Emitter<FlashcardState> emit,
  ) async {
    try {
      await repository.addCustomCard(
        word: event.word,
        categoryId: event.categoryId,
        image: event.image,
      );
      final category = state.selectedCategory;
      if (category == null) return;
      final cards = await repository.getCardsByCategory(category.id);
      emit(state.copyWith(
        cards: cards,
        currentIndex: cards.length - 1,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString(),
      ));
    }
  }
}
