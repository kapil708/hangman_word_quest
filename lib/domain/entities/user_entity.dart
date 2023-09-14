import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class UserEntity extends Equatable {
  final String id;
  @JsonKey(name: 'is_anonymous', defaultValue: false)
  final bool isAnonymous;
  final String? name;
  final String? image;

  const UserEntity({required this.id, required this.isAnonymous, this.name, this.image});

  @override
  List<Object?> get props => [id, name, isAnonymous, image];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'is_anonymous': isAnonymous,
        'image': image,
      };
}
