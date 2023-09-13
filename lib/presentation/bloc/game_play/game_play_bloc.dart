import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/word_entity.dart';
import '../../../domain/use_cases/word_user_case.dart';

part 'game_play_event.dart';
part 'game_play_state.dart';

class GamePlayBloc extends Bloc<GamePlayEvent, GamePlayState> {
  final WordUseCase wordUseCase;

  List<String> wrongAlphabets = [];
  List<String> correctAlphabets = [];
  int attempt = 0;
  WordEntity word = const WordEntity(id: '1', categoryId: '1', name: '', hint: '');

  GamePlayBloc({required this.wordUseCase}) : super(STGamePlayInitial()) {
    on<OnGamePlayInit>(onGamePlayInit);
    on<CharacterClick>(onCharacterClick);
    on<Retry>(onRetry);
  }

  onGamePlayInit(OnGamePlayInit event, Emitter<GamePlayState> emit) async {
    emit(STWordLoading());

    final response = await wordUseCase.getWordByType('1');

    response.fold((failure) {
      String message = _mapFailureToMessage(failure) ?? '';
      emit(STWordFailed(message));
    }, (data) {
      word = data;
      emit(STWordLoaded(data));
    });
  }

  onCharacterClick(CharacterClick event, Emitter<GamePlayState> emit) async {
    if (word.name.toLowerCase().contains(event.character)) {
      int matchCount = event.character.allMatches(word.name).length;
      correctAlphabets.addAll(List.filled(matchCount, event.character));

      if (word.name.length == correctAlphabets.length) {
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

  String? _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ValidationFailure:
        ValidationFailure vf = failure as ValidationFailure;
        if (vf.errors != null) {
          return vf.errors['message']?[0] ?? vf.errors['username']?[0];
        } else {
          return vf.message;
        }
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return 'No internet connected';
      default:
        return null;
    }
  }
}
