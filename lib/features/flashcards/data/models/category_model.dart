import 'package:flutter/widgets.dart';

class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final int colorIndex;
  final IconData icon;

  CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorIndex,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'colorIndex': colorIndex,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      emoji: map['emoji'] as String,
      colorIndex: map['colorIndex'] as int,
      icon: map['icon'] as IconData,
    );
  }
}
