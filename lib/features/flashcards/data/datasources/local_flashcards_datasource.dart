import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';
import '../models/flashcard_model.dart';
import '../models/category_model.dart';

class LocalFlashcardsDataSource {
  Box<String> get _cardImagesBox => Hive.box<String>('card_images');

  Box get _customCardsBox => Hive.box('custom_cards');

  Future<Directory> get _customImagesDir async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/custom_images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String? getCustomImagePath(String cardId) => _cardImagesBox.get(cardId);

  Map<String, String> getAllCustomImages() =>
      Map<String, String>.from(_cardImagesBox.toMap());

  Future<String> saveCustomImage(String cardId, File source) async {
    final ext = source.path.contains('.') ? source.path.split('.').last : 'jpg';
    final dir = await _customImagesDir;
    final target = '${dir.path}/${cardId}_${DateTime.now().millisecondsSinceEpoch}.$ext';
    await source.copy(target);
    await _cardImagesBox.put(cardId, target);
    return target;
  }

  List<FlashcardModel> getCustomCards({String? categoryId}) {
    final raw = _customCardsBox.get('cards', defaultValue: <Map<String, dynamic>>[]);
    final models = <FlashcardModel>[];
    for (final item in raw) {
      if (item is Map) {
        models.add(FlashcardModel.fromMap(Map<String, dynamic>.from(item)));
      }
    }
    if (categoryId == null) return models;
    return models.where((m) => m.categoryId == categoryId).toList();
  }

  Future<String> addCustomCard({
    required String word,
    required String categoryId,
    required File source,
  }) async {
    final dir = await _customImagesDir;
    final ts = DateTime.now().millisecondsSinceEpoch;
    final ext = source.path.contains('.') ? source.path.split('.').last : 'jpg';
    final safeWord = word.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final target = '${dir.path}/${categoryId}_${safeWord}_$ts.$ext';
    await source.copy(target);

    final id = 'custom_${categoryId}_$ts';
    final model = FlashcardModel(
      id: id,
      word: word,
      imagePath: target,
      audioPath: '',
      categoryId: categoryId,
    );
    final cards = List<Map<String, dynamic>>.from(
      _customCardsBox.get('cards', defaultValue: <Map<String, dynamic>>[]),
    )..add(model.toMap());
    await _customCardsBox.put('cards', cards);
    return id;
  }

  List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: 'mix', name: 'Mix', emoji: '🎲', colorIndex: 12, icon: Iconsax.shuffle),
      CategoryModel(id: 'animals', name: 'Animales', emoji: '🐾', colorIndex: 0, icon: Iconsax.pet),
      CategoryModel(id: 'fruits', name: 'Frutas', emoji: '🍎', colorIndex: 1, icon: Iconsax.cake),
      CategoryModel(id: 'colors', name: 'Colores', emoji: '🎨', colorIndex: 2, icon: Iconsax.color_swatch),
      CategoryModel(id: 'vehicles', name: 'Vehículos', emoji: '🚗', colorIndex: 3, icon: Iconsax.car),
      CategoryModel(id: 'body_parts', name: 'Cuerpo', emoji: '👶', colorIndex: 4, icon: Iconsax.user),
      CategoryModel(id: 'home', name: 'Hogar', emoji: '🏠', colorIndex: 5, icon: Iconsax.home_2),
      CategoryModel(id: 'clothing', name: 'Ropa', emoji: '👕', colorIndex: 6, icon: Iconsax.bag_2),
      CategoryModel(id: 'family', name: 'Familia', emoji: '👨‍👩‍👧', colorIndex: 7, icon: Iconsax.people),
      CategoryModel(id: 'emotions', name: 'Emociones', emoji: '😊', colorIndex: 8, icon: Iconsax.emoji_happy),
      CategoryModel(id: 'food', name: 'Comida', emoji: '🍞', colorIndex: 9, icon: Iconsax.coffee),
      CategoryModel(id: 'nature', name: 'Naturaleza', emoji: '🌿', colorIndex: 10, icon: Iconsax.tree),
      CategoryModel(id: 'numbers', name: 'Números', emoji: '🔢', colorIndex: 11, icon: Iconsax.hashtag),
    ];
  }

List<FlashcardModel> getCardsByCategory(String categoryId) {
  final allCards = [..._getAllCards(), ...getCustomCards()];
  if (categoryId == 'mix') {
    final shuffled = List<FlashcardModel>.from(allCards)..shuffle();
    return shuffled;
  }
  return allCards
      .where((card) => card.categoryId == categoryId)
      .toList();
}

  List<FlashcardModel> _getAllCards() {
    return [
      // Animales
      FlashcardModel(id: 'dog', word: 'Perro', imagePath: 'assets/images/dog.png', audioPath: 'dog.mp3', categoryId: 'animals'),
      FlashcardModel(id: 'cat', word: 'Gato', imagePath: 'assets/images/cat.png', audioPath: 'cat.mp3', categoryId: 'animals'),
      FlashcardModel(id: 'cow', word: 'Vaca', imagePath: 'assets/images/cow.png', audioPath: 'cow.mp3', categoryId: 'animals'),
      FlashcardModel(id: 'chicken', word: 'Gallina', imagePath: 'assets/images/chicken.png', audioPath: 'chicken.mp3', categoryId: 'animals'),
      FlashcardModel(id: 'horse', word: 'Caballo', imagePath: 'assets/images/horse.png', audioPath: 'horse.mp3', categoryId: 'animals'),
      FlashcardModel(id: 'rabbit', word: 'Conejo', imagePath: 'assets/images/rabbit.png', audioPath: 'rabbit.mp3', categoryId: 'animals'),

      // Frutas
      FlashcardModel(id: 'apple', word: 'Manzana', imagePath: 'assets/images/apple.png', audioPath: 'apple.mp3', categoryId: 'fruits'),
      FlashcardModel(id: 'banana', word: 'Plátano', imagePath: 'assets/images/banana.png', audioPath: 'banana.mp3', categoryId: 'fruits'),
      FlashcardModel(id: 'orange', word: 'Naranja', imagePath: 'assets/images/orange.png', audioPath: 'orange.mp3', categoryId: 'fruits'),
      FlashcardModel(id: 'grape', word: 'Uva', imagePath: 'assets/images/grape.png', audioPath: 'grape.mp3', categoryId: 'fruits'),
      FlashcardModel(id: 'watermelon', word: 'Sandía', imagePath: 'assets/images/watermelon.png', audioPath: 'watermelon.mp3', categoryId: 'fruits'),
      FlashcardModel(id: 'strawberry', word: 'Fresa', imagePath: 'assets/images/strawberry.png', audioPath: 'strawberry.mp3', categoryId: 'fruits'),

      // Colores
      FlashcardModel(id: 'red', word: 'Rojo', imagePath: 'assets/images/red.png', audioPath: 'red.mp3', categoryId: 'colors'),
      FlashcardModel(id: 'blue', word: 'Azul', imagePath: 'assets/images/blue.png', audioPath: 'blue.mp3', categoryId: 'colors'),
      FlashcardModel(id: 'yellow', word: 'Amarillo', imagePath: 'assets/images/yellow.png', audioPath: 'yellow.mp3', categoryId: 'colors'),
      FlashcardModel(id: 'green', word: 'Verde', imagePath: 'assets/images/green.png', audioPath: 'green.mp3', categoryId: 'colors'),
      FlashcardModel(id: 'purple', word: 'Morado', imagePath: 'assets/images/purple.png', audioPath: 'purple.mp3', categoryId: 'colors'),
      FlashcardModel(id: 'pink', word: 'Rosa', imagePath: 'assets/images/pink.png', audioPath: 'pink.mp3', categoryId: 'colors'),

      // Vehículos
      FlashcardModel(id: 'car', word: 'Coche', imagePath: 'assets/images/car.png', audioPath: 'car.mp3', categoryId: 'vehicles'),
      FlashcardModel(id: 'airplane', word: 'Avión', imagePath: 'assets/images/airplane.png', audioPath: 'airplane.mp3', categoryId: 'vehicles'),
      FlashcardModel(id: 'boat', word: 'Barco', imagePath: 'assets/images/boat.png', audioPath: 'boat.mp3', categoryId: 'vehicles'),
      FlashcardModel(id: 'train', word: 'Tren', imagePath: 'assets/images/train.png', audioPath: 'train.mp3', categoryId: 'vehicles'),
      FlashcardModel(id: 'bicycle', word: 'Bicicleta', imagePath: 'assets/images/bicycle.png', audioPath: 'bicycle.mp3', categoryId: 'vehicles'),
      FlashcardModel(id: 'bus', word: 'Autobús', imagePath: 'assets/images/bus.png', audioPath: 'bus.mp3', categoryId: 'vehicles'),

      // Cuerpo
      FlashcardModel(id: 'hand', word: 'Mano', imagePath: 'assets/images/hand.png', audioPath: 'hand.mp3', categoryId: 'body_parts'),
      FlashcardModel(id: 'eye', word: 'Ojo', imagePath: 'assets/images/eye.png', audioPath: 'eye.mp3', categoryId: 'body_parts'),
      FlashcardModel(id: 'mouth', word: 'Boca', imagePath: 'assets/images/mouth.png', audioPath: 'mouth.mp3', categoryId: 'body_parts'),
      FlashcardModel(id: 'nose', word: 'Nariz', imagePath: 'assets/images/nose.png', audioPath: 'nose.mp3', categoryId: 'body_parts'),
      FlashcardModel(id: 'ear', word: 'Oreja', imagePath: 'assets/images/ear.png', audioPath: 'ear.mp3', categoryId: 'body_parts'),
      FlashcardModel(id: 'foot', word: 'Pie', imagePath: 'assets/images/foot.png', audioPath: 'foot.mp3', categoryId: 'body_parts'),

      // Hogar
      FlashcardModel(id: 'table', word: 'Mesa', imagePath: 'assets/images/table.png', audioPath: 'table.mp3', categoryId: 'home'),
      FlashcardModel(id: 'chair', word: 'Silla', imagePath: 'assets/images/chair.png', audioPath: 'chair.mp3', categoryId: 'home'),
      FlashcardModel(id: 'bed', word: 'Cama', imagePath: 'assets/images/bed.png', audioPath: 'bed.mp3', categoryId: 'home'),
      FlashcardModel(id: 'door', word: 'Puerta', imagePath: 'assets/images/door.png', audioPath: 'door.mp3', categoryId: 'home'),
      FlashcardModel(id: 'window', word: 'Ventana', imagePath: 'assets/images/window.png', audioPath: 'window.mp3', categoryId: 'home'),
      FlashcardModel(id: 'lamp', word: 'Lámpara', imagePath: 'assets/images/lamp.png', audioPath: 'lamp.mp3', categoryId: 'home'),

      // Ropa
      FlashcardModel(id: 'shirt', word: 'Camisa', imagePath: 'assets/images/shirt.png', audioPath: 'shirt.mp3', categoryId: 'clothing'),
      FlashcardModel(id: 'shoe', word: 'Zapato', imagePath: 'assets/images/shoe.png', audioPath: 'shoe.mp3', categoryId: 'clothing'),
      FlashcardModel(id: 'hat', word: 'Sombrero', imagePath: 'assets/images/hat.png', audioPath: 'hat.mp3', categoryId: 'clothing'),
      FlashcardModel(id: 'pants', word: 'Pantalón', imagePath: 'assets/images/pants.png', audioPath: 'pants.mp3', categoryId: 'clothing'),
      FlashcardModel(id: 'dress', word: 'Vestido', imagePath: 'assets/images/dress.png', audioPath: 'dress.mp3', categoryId: 'clothing'),
      FlashcardModel(id: 'sock', word: 'Calcetín', imagePath: 'assets/images/sock.png', audioPath: 'sock.mp3', categoryId: 'clothing'),

      // Familia
      FlashcardModel(id: 'mom', word: 'Mamá', imagePath: 'assets/images/mom.png', audioPath: 'mom.mp3', categoryId: 'family'),
      FlashcardModel(id: 'dad', word: 'Papá', imagePath: 'assets/images/dad.png', audioPath: 'dad.mp3', categoryId: 'family'),
      FlashcardModel(id: 'brother', word: 'Hermano', imagePath: 'assets/images/brother.png', audioPath: 'brother.mp3', categoryId: 'family'),
      FlashcardModel(id: 'sister', word: 'Hermana', imagePath: 'assets/images/sister.png', audioPath: 'sister.mp3', categoryId: 'family'),
      FlashcardModel(id: 'baby', word: 'Bebé', imagePath: 'assets/images/baby.png', audioPath: 'baby.mp3', categoryId: 'family'),
      FlashcardModel(id: 'grandma', word: 'Abuela', imagePath: 'assets/images/grandma.png', audioPath: 'grandma.mp3', categoryId: 'family'),

      // Emociones
      FlashcardModel(id: 'happy', word: 'Feliz', imagePath: 'assets/images/happy.png', audioPath: 'happy.mp3', categoryId: 'emotions'),
      FlashcardModel(id: 'sad', word: 'Triste', imagePath: 'assets/images/sad.png', audioPath: 'sad.mp3', categoryId: 'emotions'),
      FlashcardModel(id: 'angry', word: 'Enojado', imagePath: 'assets/images/angry.png', audioPath: 'angry.mp3', categoryId: 'emotions'),
      FlashcardModel(id: 'surprised', word: 'Sorprendido', imagePath: 'assets/images/surprised.png', audioPath: 'surprised.mp3', categoryId: 'emotions'),
      FlashcardModel(id: 'scared', word: 'Asustado', imagePath: 'assets/images/scared.png', audioPath: 'scared.mp3', categoryId: 'emotions'),
      FlashcardModel(id: 'love', word: 'Amor', imagePath: 'assets/images/love.png', audioPath: 'love.mp3', categoryId: 'emotions'),

      // Comida
      FlashcardModel(id: 'bread', word: 'Pan', imagePath: 'assets/images/bread.png', audioPath: 'bread.mp3', categoryId: 'food'),
      FlashcardModel(id: 'milk', word: 'Leche', imagePath: 'assets/images/milk.png', audioPath: 'milk.mp3', categoryId: 'food'),
      FlashcardModel(id: 'rice', word: 'Arroz', imagePath: 'assets/images/rice.png', audioPath: 'rice.mp3', categoryId: 'food'),
      FlashcardModel(id: 'egg', word: 'Huevo', imagePath: 'assets/images/egg.png', audioPath: 'egg.mp3', categoryId: 'food'),
      FlashcardModel(id: 'cheese', word: 'Queso', imagePath: 'assets/images/cheese.png', audioPath: 'cheese.mp3', categoryId: 'food'),
      FlashcardModel(id: 'cookie', word: 'Galleta', imagePath: 'assets/images/cookie.png', audioPath: 'cookie.mp3', categoryId: 'food'),

      // Naturaleza
      FlashcardModel(id: 'sun', word: 'Sol', imagePath: 'assets/images/sun.png', audioPath: 'sun.mp3', categoryId: 'nature'),
      FlashcardModel(id: 'tree', word: 'Árbol', imagePath: 'assets/images/tree.png', audioPath: 'tree.mp3', categoryId: 'nature'),
      FlashcardModel(id: 'flower', word: 'Flor', imagePath: 'assets/images/flower.png', audioPath: 'flower.mp3', categoryId: 'nature'),
      FlashcardModel(id: 'rain', word: 'Lluvia', imagePath: 'assets/images/rain.png', audioPath: 'rain.mp3', categoryId: 'nature'),
      FlashcardModel(id: 'star', word: 'Estrella', imagePath: 'assets/images/star.png', audioPath: 'star.mp3', categoryId: 'nature'),
      FlashcardModel(id: 'moon', word: 'Luna', imagePath: 'assets/images/moon.png', audioPath: 'moon.mp3', categoryId: 'nature'),

      // Números
      FlashcardModel(id: 'one', word: 'Uno', imagePath: 'assets/images/one.png', audioPath: 'one.mp3', categoryId: 'numbers'),
      FlashcardModel(id: 'two', word: 'Dos', imagePath: 'assets/images/two.png', audioPath: 'two.mp3', categoryId: 'numbers'),
      FlashcardModel(id: 'three', word: 'Tres', imagePath: 'assets/images/three.png', audioPath: 'three.mp3', categoryId: 'numbers'),
      FlashcardModel(id: 'four', word: 'Cuatro', imagePath: 'assets/images/four.png', audioPath: 'four.mp3', categoryId: 'numbers'),
      FlashcardModel(id: 'five', word: 'Cinco', imagePath: 'assets/images/five.png', audioPath: 'five.mp3', categoryId: 'numbers'),
      FlashcardModel(id: 'ten', word: 'Diez', imagePath: 'assets/images/ten.png', audioPath: 'ten.mp3', categoryId: 'numbers'),
    ];
  }

  FlashcardModel? getCardById(String id) {
    final allCards = _getAllCards();
    try {
      return allCards.firstWhere((card) => card.id == id);
    } catch (_) {
      return null;
    }
  }
}
