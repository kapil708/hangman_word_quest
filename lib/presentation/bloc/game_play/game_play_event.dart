part of 'game_play_bloc.dart';

@immutable
abstract class GamePlayEvent extends Equatable {}

class WordLoading extends GamePlayEvent {
  @override
  List<Object?> get props => [];
}

class WordLoaded extends GamePlayEvent {
  final WordEntity word;

  WordLoaded(this.word);

  @override
  List<Object?> get props => [word];
}

class OnGamePlayInit extends GamePlayEvent {
  final String categoryId;
  final String categoryName;

  OnGamePlayInit(this.categoryId, this.categoryName);

  @override
  List<Object?> get props => [categoryId, categoryName];
}

class Retry extends GamePlayEvent {
  @override
  List<Object?> get props => [];
}

class NextGame extends GamePlayEvent {
  @override
  List<Object?> get props => [];
}

class CharacterClick extends GamePlayEvent {
  final String character;

  CharacterClick(this.character);
  @override
  List<Object?> get props => [character];
}
