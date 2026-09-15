import '../datasources/local_flashcards_datasource.dart';
import '../../domain/entities/flashcard_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/flashcards_repository.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  final LocalFlashcardsDataSource dataSource;

  FlashcardsRepositoryImpl({required this.dataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final models = dataSource.getCategories();
    return models.map((model) => CategoryEntity(
      id: model.id,
      name: model.name,
      emoji: model.emoji,
      colorIndex: model.colorIndex,
      icon: model.icon,
    )).toList();
  }

  @override
  Future<List<FlashcardEntity>> getCardsByCategory(String categoryId) async {
    final models = dataSource.getCardsByCategory(categoryId);
    return models.map((model) => FlashcardEntity(
      id: model.id,
      word: model.word,
      imagePath: model.imagePath,
      audioPath: model.audioPath,
      categoryId: model.categoryId,
    )).toList();
  }

  @override
  Future<FlashcardEntity?> getCardById(String id) async {
    final model = dataSource.getCardById(id);
    if (model == null) return null;
    return FlashcardEntity(
      id: model.id,
      word: model.word,
      imagePath: model.imagePath,
      audioPath: model.audioPath,
      categoryId: model.categoryId,
    );
  }
}
