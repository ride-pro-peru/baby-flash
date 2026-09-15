import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';

import 'package:baby_flash/features/flashcards/presentation/bloc/flashcards_bloc.dart';
import 'package:baby_flash/features/flashcards/presentation/pages/flashcards_page.dart';
import 'package:baby_flash/features/flashcards/domain/repositories/flashcards_repository.dart';
import 'package:baby_flash/features/flashcards/domain/entities/flashcard_entity.dart';
import 'package:baby_flash/features/flashcards/domain/entities/category_entity.dart';

class _FakeRepository implements FlashcardsRepository {
  @override
  Future<List<CategoryEntity>> getCategories() async {
    return const [
      CategoryEntity(id: 'animals', name: 'Animales', emoji: '🐾', colorIndex: 0, icon: Iconsax.pet),
    ];
  }

  @override
  Future<List<FlashcardEntity>> getCardsByCategory(String categoryId) async {
    return const [
      FlashcardEntity(
        id: 'dog',
        word: 'Perro',
        imagePath: 'assets/images/dog.png',
        audioPath: 'dog.mp3',
        categoryId: 'animals',
      ),
    ];
  }

  @override
  Future<FlashcardEntity?> getCardById(String id) async => null;

  @override
  Future<Map<String, String>> getAllCustomImages() async => const {};

  @override
  Future<String> saveCardImage(String cardId, File image) async => image.path;

  @override
  Future<String> addCustomCard({
    required String word,
    required String categoryId,
    required File image,
  }) async {
    return 'custom_${categoryId}_test';
  }
}

void main() {
  testWidgets('FlashcardsPage shows categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => FlashcardsBloc(repository: _FakeRepository()),
        child: const CupertinoApp(home: FlashcardsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('¡Hola! 👋'), findsOneWidget);
    expect(find.text('Animales'), findsOneWidget);
  });

  testWidgets('FlashcardsPage adds new-card slot after last card',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => FlashcardsBloc(repository: _FakeRepository()),
        child: const CupertinoApp(home: FlashcardsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Animales'));
    await tester.pumpAndSettle();

    expect(find.text('1 / 2'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();

    expect(find.text('Nueva tarjeta'), findsOneWidget);
    expect(find.text('2 / 2'), findsOneWidget);
  });

  testWidgets('FlashcardsPage shows change-photo button on a card',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => FlashcardsBloc(repository: _FakeRepository()),
        child: const CupertinoApp(home: FlashcardsPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Animales'));
    await tester.pumpAndSettle();

    expect(find.text('Cambiar foto desde galería'), findsOneWidget);
  });
}