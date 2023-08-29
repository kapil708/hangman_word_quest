import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class WordEntity extends Equatable {
  final String id;
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String name;
  final String hint;

  const WordEntity({required this.id, required this.categoryId, required this.name, required this.hint});

  @override
  List<Object?> get props => [id, categoryId, name, hint];
}
