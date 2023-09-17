import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/word_entity.dart';

abstract class WordRepository {
  Future<Either<RemoteFailure, List<CategoryEntity>>> getCategoryList();
  Future<Either<RemoteFailure, WordEntity>> getWordByType({required String categoryId});
  Future<Either<RemoteFailure, Map<String, dynamic>>> updatePlayedWord({required String wordId, required int score});
  Future<Either<RemoteFailure, List<WordEntity>>> getWordListByType(String categoryId);
}
