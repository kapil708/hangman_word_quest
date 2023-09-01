import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/word_entity.dart';

abstract class WordRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategoryList();
  Future<Either<Failure, WordEntity>> getWordByType(String categoryId);
  Future<Either<Failure, List<WordEntity>>> getWordListByType(String categoryId);
}
