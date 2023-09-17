import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/category_entity.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class WordUseCase {
  final WordRepository wordRepository;

  WordUseCase({required this.wordRepository});

  Future<Either<RemoteFailure, List<CategoryEntity>>> getCategoryList() async {
    return wordRepository.getCategoryList();
  }

  Future<Either<RemoteFailure, WordEntity>> getWordByType({required String categoryId}) async {
    return wordRepository.getWordByType(categoryId: categoryId);
  }

  Future<Either<RemoteFailure, bool>> updatePlayedWord({required String wordId, required int score}) async {
    return wordRepository.updatePlayedWord(wordId: wordId, score: score);
  }

  Future<Either<RemoteFailure, List<WordEntity>>> getWordListByType(String categoryId) async {
    return wordRepository.getWordListByType(categoryId);
  }
}
