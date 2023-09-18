import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_sources/local_data_source.dart';
import '../../../domain/use_cases/login_user_case.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final LoginUseCase loginUseCase;
  final LocalDataSource localDataSource;

  SplashBloc({required this.loginUseCase, required this.localDataSource}) : super(STInitial()) {
    on<Init>(onInit);
  }

  onInit(Init event, Emitter<SplashState> emit) async {
    // get user data
    var userData = localDataSource.getUser();
    if (userData == null) {
      emit(STLogin());
    } else {
      emit(STHome());
    }
  }
}
