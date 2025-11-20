abstract class QuizServiceInterface {
  Future<dynamic> getQuizList({
    required int amount,
    int? category,
    String? difficulty,
    String? type,
  });
}
