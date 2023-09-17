import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/word_entity.dart';
import '../../../domain/use_cases/word_user_case.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  final WordUseCase wordUseCase;

  String categoryId = "";
  String categoryName = "";
  List<String> wrongAlphabets = [];
  List<String> correctAlphabets = [];
  int attempt = 0;
  WordEntity word = const WordEntity(id: '1', categoryId: '1', name: '', hint: '');

  GamePlayBloc({required this.wordUseCase}) : super(STGamePlayInitial()) {
    on<OnGamePlayInit>(onGamePlayInit);
    on<CharacterClick>(onCharacterClick);
    on<Retry>(onRetry);
    on<NextGame>(onNextGame);
  }

  onGamePlayInit(OnGamePlayInit event, Emitter<GamePlayState> emit) async {
    emit(STWordLoading());

    categoryId = event.categoryId;
    categoryName = event.categoryName;

    final response = await wordUseCase.getWordByType(categoryId: categoryId);

    response.fold((failure) {
      print("failure: ${failure.statusCode}");
      emit(STWordFailed(failure.message));
    }, (data) {
      word = data;
      emit(STWordLoaded(data));
    });
  }

  onCharacterClick(CharacterClick event, Emitter<GamePlayState> emit) async {
    print("event.character : ${event.character}, word.name : ${word.name.toLowerCase().contains(event.character)}");
    if (word.name.toLowerCase().contains(event.character)) {
      int matchCount = event.character.allMatches(word.name.toLowerCase()).length;
      correctAlphabets.addAll(List.filled(matchCount, event.character));

      if (word.name.length == correctAlphabets.length) {
        int score = 6 - attempt;
        await wordUseCase.updatePlayedWord(wordId: word.id, score: score);
        emit(STWinner());
      } else {
        emit(STCorrectAlphabets(correctAlphabets));
      }
    } else {
      wrongAlphabets.add(event.character);
      attempt++;

      if (attempt < 6) {
        emit(STWrongAlphabets(wrongAlphabets, attempt));
      } else {
        emit(STAttemptOver());
      }
    }
  }

  onRetry(Retry event, Emitter<GamePlayState> emit) {
    wrongAlphabets = [];
    correctAlphabets = [];
    attempt = 0;

    emit(STGamePlayReload());
  }

  onNextGame(NextGame event, Emitter<GamePlayState> emit) async {
    emit(STWordLoading());

    final response = await wordUseCase.getWordByType(categoryId: categoryId);

    response.fold((failure) {
      emit(STWordFailed(failure.message));
    }, (data) {
      wrongAlphabets = [];
      correctAlphabets = [];
      attempt = 0;
      word = data;
      emit(STWordLoaded(data));
    });
  }
}
