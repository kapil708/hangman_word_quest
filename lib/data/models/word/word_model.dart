import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/word_entity.dart';

part 'word_model.g.dart';

@JsonSerializable()
class WordModel extends WordEntity {
  const WordModel({required super.id, required super.name, required super.categoryId, required super.hint});

  factory WordModel.fromJson(Map<String, dynamic> json) => _$WordModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordModelToJson(this);
}
