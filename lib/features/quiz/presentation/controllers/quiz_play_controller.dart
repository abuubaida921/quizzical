import 'package:get/get.dart';
import '../../domain/models/quiz_model.dart';
import 'quiz_controller.dart';
import '../../../../routes/app_pages.dart';

class QuizPlayController extends GetxController {
  final QuizController quizController = Get.find<QuizController>();

  // States
  final RxInt currentIndex = 0.obs;
  final RxBool showFeedback = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxList<String> currentOptions = <String>[].obs;

  // Get questions list from QuizController
  List<QuestionModel> get questions => quizController.questionList ?? [];

  QuestionModel get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    _loadOptionsForCurrentQuestion();
  }


  // Shuffled options (auto handles boolean/multiple)
  List<String> get options {
    if (currentQuestion.type == "boolean") {
      return ["True", "False"];
    } else {
      final list = [...currentQuestion.incorrectAnswers, currentQuestion.correctAnswer];
      list.shuffle();
      return list;
    }
  }

  // Normalize Strings
  String normalize(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

  // Submit Answer
  void submitAnswer(String answer) {
    if (showFeedback.value) return;

    selectedAnswer.value = answer;
    showFeedback.value = true;

    if (normalize(answer) == normalize(currentQuestion.correctAnswer)) {
      score.value++;
    }
  }

  // Move to next
  void next() {
    if (!showFeedback.value) return;

    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      showFeedback.value = false;
      selectedAnswer.value = "";
      _loadOptionsForCurrentQuestion();  // ← FIX
    } else {
      Get.offNamed(AppPages.resultsPage, arguments: {
        "score": score.value,
        "total": questions.length,
      });
    }
  }


  String get progressText =>
      "${currentIndex.value + 1}/${questions.length}";

  void _loadOptionsForCurrentQuestion() {
    final q = currentQuestion;

    if (q.type == "boolean") {
      currentOptions.value = ["True", "False"];
    } else {
      final list = [...q.incorrectAnswers, q.correctAnswer];
      list.shuffle();
      currentOptions.value = list;
    }
  }

}
