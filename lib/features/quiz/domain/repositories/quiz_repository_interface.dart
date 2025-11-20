import '../../../../core/interface/repo_interface.dart';

abstract class QuizRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getQuizList({
    required int amount,
    required int categoryId,
    String? difficulty,
    String? type,
  });
}
