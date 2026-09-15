import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final int colorIndex;
  final IconData icon;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorIndex,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, emoji, colorIndex, icon];
}
