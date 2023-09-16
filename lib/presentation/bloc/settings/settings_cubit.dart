import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman_word_quest/data/models/user/user_model.dart';
import 'package:hangman_word_quest/domain/entities/user_entity.dart';

import '../../../data/data_sources/local_data_source.dart';
import '../../../domain/use_cases/login_user_case.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final LoginUseCase loginUseCase;
  final LocalDataSource localDataSource;

  SettingsCubit({required this.loginUseCase, required this.localDataSource}) : super(STInitial());

  UserEntity? userEntity;

  void init() {
    // get user data
    var userData = localDataSource.getUser();
    userEntity = UserModel.fromJson(userData);
    emit(STInitialDone());
  }

  void googleSignIn() async {
    final response = await loginUseCase.googleLogin();
    response.fold(
      (failure) {
        emit(STLoginFailed(failure.message));
      },
      (data) {
        localDataSource.cacheUser(data.toJson());
        userEntity = data;
        emit(STLoginSuccess());
      },
    );
  }
}
