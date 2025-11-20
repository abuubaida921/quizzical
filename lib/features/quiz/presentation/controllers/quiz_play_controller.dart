import 'package:get/get.dart';
import '../../domain/models/quiz_model.dart';
import 'quiz_controller.dart';
import '../../../../routes/app_pages.dart';

class QuizPlayController extends GetxController {
  final QuizController quizController = Get.find<QuizController>();

  final RxInt currentIndex = 0.obs;
  final RxBool showFeedback = false.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxList<String> currentOptions = <String>[].obs;

  List<QuestionModel> get questions => quizController.questionList ?? [];
  QuestionModel get currentQuestion => questions[currentIndex.value];

  @override
  void onInit() {
    super.onInit();
    _loadOptionsForCurrentQuestion();
  }

  String normalize(String s) =>
      s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

  // Load shuffled options
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

  // Submit answer
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
      selectedAnswer.value = "";
      showFeedback.value = false;
      _loadOptionsForCurrentQuestion();
    } else {
      Get.offNamed(AppPages.resultsPage, arguments: {
        "score": score.value,
        "total": questions.length,
      });
    }
  }

  String get progressText => "${currentIndex.value + 1}/${questions.length}";
}
