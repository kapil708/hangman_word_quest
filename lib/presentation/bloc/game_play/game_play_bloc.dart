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

  GamePlayBloc({required this.wordUseCase}) : super(GamePlayState()) {
    on<OnGamePlayInit>(onGamePlayInit);
    on<CharacterClick>(onCharacterClick);
  }

  onGamePlayInit(OnGamePlayInit event, Emitter<GamePlayState> emit) async {
    emit(state.copyWith(isLoading: true));

    final response = await wordUseCase.getWordByType('1');

    response.fold((failure) {
      String message = _mapFailureToMessage(failure) ?? '';
      emit(WordFailed(message));
    }, (data) {
      emit(state.copyWith(word: data));
    });
  }

  onCharacterClick(CharacterClick event, Emitter<GamePlayState> emit) async {
    if (word.toLowerCase().contains(character)) {
      correctAlphabets.add(character);
    } else {
      wrongAlphabets.add(character);
      attempt++;
    }
    setState(() {});

    if (attempt == 6) {
      showFailedDialog();
    }

    emit(state.copyWith(isLoading: true));

    final response = await wordUseCase.getWordByType('1');

    response.fold((failure) {
      String message = _mapFailureToMessage(failure) ?? '';
      emit(WordFailed(message));
    }, (data) {
      emit(state.copyWith(word: data));
    });
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
