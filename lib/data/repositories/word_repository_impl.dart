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
  Future<Either<RemoteFailure, List<CategoryEntity>>> getCategoryList() async {
    if (await networkInfo.isConnected) {
      try {
        final categoryList = await remoteDataSource.getCategoryList();
        return Right(categoryList);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection'));
    }
  }

  @override
  Future<Either<RemoteFailure, WordEntity>> getWordByType({required String categoryId}) async {
    if (await networkInfo.isConnected) {
      try {
        final word = await remoteDataSource.getWordByType(categoryId: categoryId);
        return Right(word);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection'));
    }
  }

  @override
  Future<Either<RemoteFailure, Map<String, dynamic>>> updatePlayedWord({required String wordId, required String categoryId, required int score}) async {
    if (await networkInfo.isConnected) {
      try {
        final val = await remoteDataSource.updatePlayedWord(wordId: wordId, categoryId: categoryId, score: score);
        return Right(val);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection'));
    }
  }

  @override
  Future<Either<RemoteFailure, List<WordEntity>>> getWordListByType(String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final wordList = await remoteDataSource.getWordListByType(categoryId);
        return Right(wordList);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection'));
    }
  }

  @override
  Future<Either<RemoteFailure, bool>> linkWordIds() async {
    if (await networkInfo.isConnected) {
      try {
        final wordList = await remoteDataSource.linkWordIds();
        return Right(wordList);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection'));
    }
  }
}
