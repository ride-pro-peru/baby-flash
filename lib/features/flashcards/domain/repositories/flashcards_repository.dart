import '../entities/flashcard_entity.dart';
import '../entities/category_entity.dart';

abstract class FlashcardsRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<FlashcardEntity>> getCardsByCategory(String categoryId);
  Future<FlashcardEntity?> getCardById(String id);
}
