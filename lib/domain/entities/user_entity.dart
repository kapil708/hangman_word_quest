import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class UserEntity extends Equatable {
  final String id;
  @JsonKey(name: 'is_anonymous', defaultValue: false)
  final bool isAnonymous;
  final String? name;
  final String? image;
  final int? level;
  final int? score;

  const UserEntity({
    required this.id,
    required this.isAnonymous,
    this.name,
    this.image,
    this.level,
    this.score,
  });

  @override
  List<Object?> get props => [id, name, isAnonymous, image, level, score];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'is_anonymous': isAnonymous,
        'image': image,
        'level': level,
        'score': score,
      };
}
