import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_sources/local_data_source.dart';
import '../../../domain/use_cases/login_user_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final LocalDataSource localDataSource;

  LoginCubit({
    required this.loginUseCase,
    required this.localDataSource,
  }) : super(LoginInitial());

  void anonymousLogin() async {
    final response = await loginUseCase.googleAnonymousLogin();
    response.fold(
      (failure) {
        emit(STLoginFailed(failure.message));
      },
      (data) {
        localDataSource.cacheUser(data.toJson());
        emit(STLoginSuccess());
      },
    );
  }

  void googleSignIn() async {
    final response = await loginUseCase.googleSignIn();
    response.fold(
      (failure) {
        emit(STLoginFailed(failure.message));
      },
      (data) {
        localDataSource.cacheUser(data.toJson());
        emit(STLoginSuccess());
      },
    );
  }
}
