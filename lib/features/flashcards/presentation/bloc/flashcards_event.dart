import 'package:equatable/equatable.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends FlashcardEvent {
  const LoadCategories();
}

class SelectCategory extends FlashcardEvent {
  final String categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SwipeNext extends FlashcardEvent {
  const SwipeNext();
}

class SwipePrevious extends FlashcardEvent {
  const SwipePrevious();
}

class DeselectCategory extends FlashcardEvent {
  const DeselectCategory();
}

class PlayAudio extends FlashcardEvent {
  const PlayAudio();
}
