import 'dart:io';

import '../entities/flashcard_entity.dart';
import '../entities/category_entity.dart';

abstract class FlashcardsRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<FlashcardEntity>> getCardsByCategory(String categoryId);
  Future<FlashcardEntity?> getCardById(String id);
  Future<Map<String, String>> getAllCustomImages();
  Future<String> saveCardImage(String cardId, File image);
  Future<String> addCustomCard({
    required String word,
    required String categoryId,
    required File image,
  });
}
