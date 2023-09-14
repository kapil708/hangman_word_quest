import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/login_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, LoginEntity>> login(Map<String, dynamic> body);
  Future<Either<Failure, UserEntity>> googleAnonymousLogin();
}
