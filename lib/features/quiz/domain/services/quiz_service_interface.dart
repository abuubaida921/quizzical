abstract class QuizServiceInterface {
  Future<dynamic> getQuizList({
    required int amount,
    required int categoryId,
    String? difficulty,
    String? type,
  });
}
