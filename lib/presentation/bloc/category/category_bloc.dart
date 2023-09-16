import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        emit(CategoryFailed(failure.message));
      }, (data) {
        emit(CategoryLoaded(data));
      });
    });
  }
}
