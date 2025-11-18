import 'dart:math';

import 'package:get/get.dart';

import '../../../categories/data/datasources/trivia_remote_datasource.dart';

class QuizController extends GetxController {
  final TriviaRemoteDataSource remote;

  QuizController(this.remote);

  // State
  final isLoading = false.obs;
  final questions = <QuestionModel>[].obs;
  final currentIndex = 0.obs;
  final score = 0.obs;

  // UI state
  final selectedAnswer = RxnString();
  final showAnswerFeedback = false.obs;
  final error = RxnString();

  // Derived getters
  int get totalQuestions => questions.length;
  QuestionModel? get currentQuestion =>
      questions.isNotEmpty ? questions[currentIndex.value] : null;
  bool get isLastQuestion =>
      totalQuestions > 0 && currentIndex.value == totalQuestions - 1;
  int get currentNumber => totalQuestions == 0 ? 0 : currentIndex.value + 1;
  String get progressText => '$currentNumber / $totalQuestions';

  /// Load quiz questions from remote source based on configuration.
  /// - amount: number of questions (1-50)
  /// - categoryId: category id (0 or omitted means any)
  /// - difficulty: 'any' | 'easy' | 'medium' | 'hard' (case-insensitive)
  /// - type: 'any' | 'multiple' | 'boolean'
  Future<void> loadQuiz({
    required int amount,
    required int categoryId,
    String difficulty = 'any',
    String type = 'any',
  }) async {
    isLoading.value = true;
    error.value = null;
    try {
      // Fetch questions from remote datasource
      final items = await remote.fetchQuestions(
        amount: amount,
        categoryId: categoryId,
        difficulty: difficulty,
        type: type,
      );

      questions.assignAll(items);
      // reset progress
      currentIndex.value = 0;
      score.value = 0;
      selectedAnswer.value = null;
      showAnswerFeedback.value = false;
    } catch (e) {
      error.value = e.toString();
      // rethrow if caller wants to handle
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Returns a shuffled list of answers for the current question.
  /// Handles both "multiple" and "boolean" types.
  List<String> shuffledAnswersForCurrent({int? seed}) {
    final q = currentQuestion;
    if (q == null) return <String>[];

    if (q.type.toLowerCase() == 'boolean') {
      // For boolean questions prefer canonical order [True, False] then shuffle slightly
      final options = <String>[q.correctAnswer, ...q.incorrectAnswers];
      // ensure uniqueness and consistent capitalisation
      final dedup = options.map((s) => s.trim()).toSet().toList();
      // Shuffle using optional seed for testability
      if (seed != null) {
        final rand = Random(seed);
        dedup.shuffle(rand);
      } else {
        dedup.shuffle(Random());
      }
      return dedup;
    } else {
      final options = <String>[q.correctAnswer, ...q.incorrectAnswers].map((s) => s.trim()).toList();
      if (seed != null) {
        final rand = Random(seed);
        options.shuffle(rand);
      } else {
        options.shuffle(Random());
      }
      return options;
    }
  }

  /// Submit an answer for the current question.
  /// - Marks feedback visible and updates score if correct.
  /// - Subsequent calls while feedback shown will be ignored.
  void submitAnswer(String answer) {
    if (showAnswerFeedback.value) return; // avoid double submissions
    selectedAnswer.value = answer;
    showAnswerFeedback.value = true;

    final q = currentQuestion;
    if (q == null) return;

    if (answer.trim() == q.correctAnswer.trim()) {
      score.value++;
    }
    // Keep result visible until nextQuestion() is called by the UI.
  }

  /// Move to the next question or navigate to results if finished.
  /// - Resets selection/feedback for the next question.
  void nextQuestion() {
    showAnswerFeedback.value = false;
    selectedAnswer.value = null;

    if (currentIndex.value < totalQuestions - 1) {
      currentIndex.value++;
    } else {
      // finished -> navigate to results screen (replace stack so user cannot go back to quiz)
      // Make sure route '/results' exists in AppPages
      Get.offAllNamed('/results');
    }
  }

  /// Reset the quiz state (keeps questions list intact if you want to replay same quiz)
  void resetProgress({bool clearQuestions = false}) {
    if (clearQuestions) questions.clear();
    currentIndex.value = 0;
    score.value = 0;
    selectedAnswer.value = null;
    showAnswerFeedback.value = false;
    error.value = null;
  }

  /// Convenience: returns whether provided answer is correct (without changing state)
  bool isCorrectAnswer(String answer, {int? questionIndex}) {
    final q = (questionIndex != null && questionIndex >= 0 && questionIndex < questions.length)
        ? questions[questionIndex]
        : currentQuestion;
    if (q == null) return false;
    return answer.trim() == q.correctAnswer.trim();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}