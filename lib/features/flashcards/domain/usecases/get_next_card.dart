import '../entities/flashcard_entity.dart';
import '../repositories/flashcards_repository.dart';

class GetNextCard {
  final FlashcardsRepository repository;

  GetNextCard(this.repository);

  Future<FlashcardEntity?> call(String currentId, String categoryId) async {
    final cards = await repository.getCardsByCategory(categoryId);
    if (cards.isEmpty) return null;

    final currentIndex = cards.indexWhere((c) => c.id == currentId);
    if (currentIndex == -1) return cards.first;

    final nextIndex = (currentIndex + 1) % cards.length;
    return cards[nextIndex];
  }
}
