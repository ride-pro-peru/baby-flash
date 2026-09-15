import '../entities/flashcard_entity.dart';
import '../repositories/flashcards_repository.dart';

class GetCardsByCategory {
  final FlashcardsRepository repository;

  GetCardsByCategory(this.repository);

  Future<List<FlashcardEntity>> call(String categoryId) {
    return repository.getCardsByCategory(categoryId);
  }
}
