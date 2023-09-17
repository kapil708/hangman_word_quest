// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      image: json['image'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      level: json['level'] as int?,
      score: json['score'] as int?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'is_anonymous': instance.isAnonymous,
      'name': instance.name,
      'image': instance.image,
      'level': instance.level,
      'score': instance.score,
    };
