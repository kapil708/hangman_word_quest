import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/login_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<RemoteFailure, LoginEntity>> login(Map<String, dynamic> body);
  Future<Either<RemoteFailure, UserEntity>> googleAnonymousLogin();
  Future<Either<RemoteFailure, UserEntity>> googleLogin();
  Future<Either<RemoteFailure, UserEntity>> googleSignIn();
}
