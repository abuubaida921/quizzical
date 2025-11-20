import 'package:quizzical/features/quiz/domain/repositories/quiz_repository_interface.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service_interface.dart';

class QuizService implements QuizServiceInterface {
  QuizRepositoryInterface quizRepositoryInterface;
  QuizService({required this.quizRepositoryInterface});

  @override
  Future<dynamic> getQuizList({
    required int amount,
    required int categoryId,
    String? difficulty,
    String? type,
  }) async {
    return await quizRepositoryInterface.getQuizList(
      amount: amount,
      categoryId: categoryId,
      difficulty: difficulty,
      type: type,
    );
  }
}
