import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/login_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository userRepository;

  LoginUseCase({required this.userRepository});

  Future<Either<Failure, LoginEntity>> login(Map<String, dynamic> body) async {
    return userRepository.login(body);
  }

  Future<Either<Failure, UserEntity>> googleAnonymousLogin() async {
    return userRepository.googleAnonymousLogin();
  }
}
