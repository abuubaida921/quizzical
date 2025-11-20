import 'dart:developer' as dev;
import 'dart:math';
import 'package:get/get.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service_interface.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/helper/api_checker.dart';
import '../../../../data/datasource/model/api_response.dart';
import '../../domain/models/quiz_model.dart';

class QuizController extends GetxController {
  final QuizServiceInterface? quizServiceInterface;
  QuizController({required this.quizServiceInterface});

  // State
  final isLoading = false.obs;
  final questions = <QuestionModel>[].obs;
  final currentIndex = 0.obs;
  final score = 0.obs;

  // UI state
  final selectedAnswer = RxnString();
  final showAnswerFeedback = false.obs;
  final error = RxnString();

  // Cache of shuffled options per question index to keep order stable while viewing
  final Map<int, List<String>> _shuffledCache = {};

  // Derived getters
  int get totalQuestions => questions.length;
  QuestionModel? get currentQuestion =>
      questions.isNotEmpty ? questions[currentIndex.value] : null;
  bool get isLastQuestion =>
      totalQuestions > 0 && currentIndex.value == totalQuestions - 1;
  int get currentNumber => totalQuestions == 0 ? 0 : currentIndex.value + 1;
  String get progressText => '$currentNumber / $totalQuestions';


  List<QuestionModel>? _questionList;
  List<QuestionModel>? get questionList =>_questionList;

  @override
  void onInit() {
    super.onInit();

    // Whenever index changes, clear selected answer and hide feedback
    // ever(currentIndex, (_) {
    //   selectedAnswer.value = null;
    //   showAnswerFeedback.value = false;
    // });
  }

  Future<void> loadQuizList({
    required int amount,
    required int categoryId,
    String difficulty = 'any',
    String type = 'any',
  }) async {

    isLoading.value=true;
    _questionList =[];
    ApiResponse apiResponse = await quizServiceInterface?.getQuizList(amount: amount, categoryId: categoryId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200 && apiResponse.response!.data.toString() != '{}') {
      _questionList =[];
      apiResponse.response!.data['results'].forEach((cData) => _questionList?.add(QuestionModel.fromJson(cData)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    isLoading.value=false;
  }

  // Future<void> loadQuiz({
  //   required int amount,
  //   required int categoryId,
  //   String difficulty = 'any',
  //   String type = 'any',
  // }) async {
  //   isLoading.value = true;
  //   error.value = null;
  //   _shuffledCache.clear();
  //
  //   try {
  //     final raw = await remote.fetchQuestions(
  //       amount: amount,
  //       categoryId: categoryId,
  //       difficulty: difficulty,
  //       type: type,
  //     );
  //
  //     final List<QuestionModel> parsed = _parseRawQuestions(raw);
  //
  //     if (parsed.isEmpty) {
  //       throw Exception('No questions returned from API');
  //     }
  //
  //     questions.assignAll(parsed);
  //
  //     // reset progress
  //     currentIndex.value = 0;
  //     score.value = 0;
  //     selectedAnswer.value = null;
  //     showAnswerFeedback.value = false;
  //   } catch (e, st) {
  //     if (Get.isLogEnable) {
  //       if (kDebugMode) {
  //         print('QuizController.loadQuiz error: $e\n$st');
  //       }
  //     }
  //     error.value = e.toString();
  //     rethrow;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  List<QuestionModel> _parseRawQuestions(dynamic raw) {
    if (raw == null) {
      throw Exception('Empty response from questions endpoint');
    }

    if (raw is List<QuestionModel>) {
      return raw;
    }

    if (raw is Map<String, dynamic> && raw.containsKey('results')) {
      final results = raw['results'];
      if (results is List) {
        return results.map<QuestionModel>((item) {
          if (item is QuestionModel) return item;
          if (item is Map<String, dynamic>) return QuestionModel.fromJson(item);
          return QuestionModel.fromJson(Map<String, dynamic>.from(item as Map));
        }).toList();
      }
      throw FormatException('Unexpected results format in payload');
    }

    if (raw is List) {
      return raw.map<QuestionModel>((item) {
        if (item is QuestionModel) return item;
        if (item is Map<String, dynamic>) return QuestionModel.fromJson(item);
        if (item is Map) return QuestionModel.fromJson(Map<String, dynamic>.from(item));
        throw FormatException('Unsupported question item type: ${item.runtimeType}');
      }).toList();
    }

    throw FormatException('Unexpected payload from remote.fetchQuestions: ${raw.runtimeType}');
  }

  List<String> shuffledAnswersForIndex(int index, {int? seed}) {
    if (index < 0 || index >= questions.length) return <String>[];
    if (_shuffledCache.containsKey(index)) return _shuffledCache[index]!;
    final q = questions[index];
    final combined = <String>[q.correctAnswer, ...q.incorrectAnswers].map((s) => s.trim()).toList();

    if (seed != null) {
      final rand = Random(seed);
      combined.shuffle(rand);
    } else {
      combined.shuffle(Random());
    }

    _shuffledCache[index] = combined;
    return combined;
  }

  List<String> shuffledAnswersForCurrent({int? seed}) {
    return shuffledAnswersForIndex(currentIndex.value, seed: seed);
  }

  void submitAnswer(String answer) {
    if (showAnswerFeedback.value) return;
    selectedAnswer.value = answer;
    showAnswerFeedback.value = true;

    final q = currentQuestion;
    if (q == null) return;

    if (_normalize(answer) == _normalize(q.correctAnswer)) {
      score.value++;
    }
  }

  void nextQuestion() {
    showAnswerFeedback.value = false;
    selectedAnswer.value = null;

    if (currentIndex.value < totalQuestions - 1) {
      currentIndex.value++;
    } else {
      Get.offAllNamed(AppPages.resultsPage, arguments: {
        'score': score.value,
        'total': totalQuestions,
      });
    }
  }

  void resetProgress({bool clearQuestions = false}) {
    if (clearQuestions) questions.clear();
    currentIndex.value = 0;
    score.value = 0;
    selectedAnswer.value = null;
    showAnswerFeedback.value = false;
    error.value = null;
    _shuffledCache.clear();
  }

  bool isCorrectAnswer(String answer, {int? questionIndex}) {
    final q = (questionIndex != null && questionIndex >= 0 && questionIndex < questions.length)
        ? questions[questionIndex]
        : currentQuestion;
    if (q == null) return false;
    return _normalize(answer) == _normalize(q.correctAnswer);
  }

  String _decodeHtml(String input) {
    if (input.isEmpty) return input;

    var out = input.replaceAll('&quot;', '"').replaceAll('&ldquo;', '“').replaceAll('&rdquo;', '”');
    out = out.replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>');
    out = out.replaceAll('&apos;', "'").replaceAll('&#039;', "'");

    out = out.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
      final code = int.tryParse(m[1] ?? '');
      if (code == null) return m[0] ?? '';
      return String.fromCharCode(code);
    });

    out = out.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (m) {
      final code = int.tryParse(m[1] ?? '', radix: 16);
      if (code == null) return m[0] ?? '';
      return String.fromCharCode(code);
    });

    return out;
  }

  String _normalize(String s) {
    return s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }

  @override
  void onClose() {
    _shuffledCache.clear();
    super.onClose();
  }
}