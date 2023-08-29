import 'package:dartz/dartz.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/word_repository.dart';
import '../data_sources/remote_data_source.dart';

class WordRepositoryImpl implements WordRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WordRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoryList() async {
    if (await networkInfo.isConnected) {
      try {
        final categoryList = await remoteDataSource.getCategoryList();
        return Right(categoryList);
      } on ValidationException catch (e) {
        return Left(ValidationFailure(errors: e.errors, message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<WordEntity>>> getWordListByType(String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final wordList = await remoteDataSource.getWordListByType(categoryId);
        return Right(wordList);
      } on ValidationException catch (e) {
        return Left(ValidationFailure(errors: e.errors, message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
