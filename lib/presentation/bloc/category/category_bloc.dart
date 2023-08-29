import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/use_cases/word_user_case.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final WordUseCase wordUseCase;

  CategoryBloc({required this.wordUseCase}) : super(CategoryInitial()) {
    on<CategoryLoading>((event, emit) async {
      emit(CategoryLoadingState());

      final wordResponse = await wordUseCase.getCategoryList();

      wordResponse.fold((failure) {
        String message = _mapFailureToMessage(failure) ?? '';
        emit(CategoryFailed(message));
      }, (data) {
        emit(CategoryLoaded(data));
      });
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
