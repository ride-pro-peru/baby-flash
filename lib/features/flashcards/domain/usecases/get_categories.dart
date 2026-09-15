import '../entities/category_entity.dart';
import '../repositories/flashcards_repository.dart';

class GetCategories {
  final FlashcardsRepository repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
