class FlashcardModel {
  final String id;
  final String word;
  final String imagePath;
  final String audioPath;
  final String categoryId;

  FlashcardModel({
    required this.id,
    required this.word,
    required this.imagePath,
    required this.audioPath,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'categoryId': categoryId,
    };
  }

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'] as String,
      word: map['word'] as String,
      imagePath: map['imagePath'] as String,
      audioPath: map['audioPath'] as String,
      categoryId: map['categoryId'] as String,
    );
  }
}
