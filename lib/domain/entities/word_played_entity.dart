import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class WordPlayedEntity extends Equatable {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'word_id')
  final String wordId;

  const WordPlayedEntity({required this.userId, required this.wordId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, wordId];
}
