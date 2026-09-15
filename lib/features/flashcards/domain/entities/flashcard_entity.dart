import 'package:equatable/equatable.dart';

class FlashcardEntity extends Equatable {
  final String id;
  final String word;
  final String imagePath;
  final String audioPath;
  final String categoryId;

  const FlashcardEntity({
    required this.id,
    required this.word,
    required this.imagePath,
    required this.audioPath,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, word, imagePath, audioPath, categoryId];
}
