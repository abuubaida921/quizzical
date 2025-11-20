import 'package:quizzical/features/categories/domain/repositories/category_repository_interface.dart';
import 'package:quizzical/features/categories/domain/services/category_service_interface.dart';
import 'package:quizzical/features/quiz/domain/repositories/quiz_repository_interface.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service_interface.dart';

class QuizService implements QuizServiceInterface {
  QuizRepositoryInterface quizRepositoryInterface;
  QuizService({required this.quizRepositoryInterface});

  @override
  Future<dynamic> getQuizList({
    required int amount,
    int? category,
    String? difficulty,
    String? type,
  }) async {
    return await quizRepositoryInterface.getQuizList(
      amount: amount,
      category: category,
      difficulty: difficulty,
      type: type,
    );
  }
}
