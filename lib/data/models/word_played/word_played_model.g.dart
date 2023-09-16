// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_played_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordPlayedModel _$WordPlayedModelFromJson(Map<String, dynamic> json) =>
    WordPlayedModel(
      userId: json['user_id'] as String,
      wordId: json['word_id'] as String,
    );

Map<String, dynamic> _$WordPlayedModelToJson(WordPlayedModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'word_id': instance.wordId,
    };
