part of 'game_play_bloc.dart';

@immutable
class GamePlayState extends Equatable {
  GamePlayState({
    List<String>? wrongAlphabets,
    List<String>? correctAlphabets,
    int? attempt,
    bool? isLoading,
    WordEntity? word,
  })  : wrongAlphabets = wrongAlphabets ?? [],
        correctAlphabets = correctAlphabets ?? [],
        attempt = attempt ?? 0,
        isLoading = isLoading ?? false,
        word = word ?? const WordEntity(id: '1', categoryId: '1', name: 'adsdsad', hint: 'adsdsad');

  final List<String> wrongAlphabets;
  final List<String> correctAlphabets;
  final int attempt;
  final bool isLoading;
  final WordEntity word;

  GamePlayState copyWith({List<String>? wrongAlphabets, List<String>? correctAlphabets, int? attempt, WordEntity? word, bool? isLoading}) {
    return GamePlayState(
      wrongAlphabets: wrongAlphabets ?? this.wrongAlphabets,
      correctAlphabets: correctAlphabets ?? this.correctAlphabets,
      attempt: attempt ?? this.attempt,
      isLoading: isLoading ?? this.isLoading,
      word: word ?? this.word,
    );
  }

  @override
  List<Object?> get props => [wrongAlphabets, correctAlphabets, attempt];
}

class WordFailed extends GamePlayState {
  final String message;

  WordFailed(this.message);

  @override
  List<Object?> get props => [message];
}
