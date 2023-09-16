import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/word_played_entity.dart';

part 'word_played_model.g.dart';

@JsonSerializable()
class WordPlayedModel extends WordPlayedEntity {
  const WordPlayedModel({required super.userId, required super.wordId});

  factory WordPlayedModel.fromJson(Map<String, dynamic> json) => _$WordPlayedModelFromJson(json);

  Map<String, dynamic> toJson() => _$WordPlayedModelToJson(this);
}
