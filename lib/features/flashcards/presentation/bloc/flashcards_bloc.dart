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
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<FlashcardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await repository.getCategories();
      emit(state.copyWith(
        categories: categories,
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
    if (state.hasNext) {
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
    if (state.hasPrevious) {
      emit(state.copyWith(
        currentIndex: state.currentIndex - 1,
      ));
    } else {
      emit(state.copyWith(
        currentIndex: state.cards.length - 1,
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
}
