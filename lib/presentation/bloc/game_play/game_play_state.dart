part of 'game_play_bloc.dart';

@immutable
abstract class GamePlayState /* extends Equatable*/ {}

class STGamePlayInitial extends GamePlayState {
  /*@override
  List<Object?> get props => [];*/
}

class STGamePlayReload extends GamePlayState {
  /*@override
  List<Object?> get props => [];*/
}

class STCorrectAlphabets extends GamePlayState {
  final List<String> alphabets;

  STCorrectAlphabets(this.alphabets);

  /*@override
  List<Object?> get props => [alphabets];*/
}

class STWrongAlphabets extends GamePlayState {
  final List<String> alphabets;
  final int attempt;

  STWrongAlphabets(this.alphabets, this.attempt);

  /*@override
  List<Object?> get props => [alphabets, attempt];*/
}

class STAttemptOver extends GamePlayState {
  /*@override
  List<Object?> get props => [];*/
}

class STWinner extends GamePlayState {
  /*@override
  List<Object?> get props => [];*/
}

class STWordLoading extends GamePlayState {
  /*@override
  List<Object?> get props => [];*/
}

class STWordLoaded extends GamePlayState {
  final WordEntity word;

  STWordLoaded(this.word);

  /*@override
  List<Object?> get props => [word];*/
}

class STWordFailed extends GamePlayState {
  final String message;

  STWordFailed(this.message);

  /*@override
  List<Object?> get props => [message];*/
}
