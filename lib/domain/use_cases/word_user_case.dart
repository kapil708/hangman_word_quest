import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class WordUseCase {
  final WordRepository wordRepository;

  WordUseCase({required this.wordRepository});

  Future<Either<Failure, List<CategoryEntity>>> getCategoryList() async {
    return wordRepository.getCategoryList();
  }

  Future<Either<Failure, List<WordEntity>>> getWordListByType(String categoryId) async {
    return wordRepository.getWordListByType(categoryId);
  }
}
