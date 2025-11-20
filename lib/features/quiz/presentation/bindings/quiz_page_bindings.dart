import 'package:get/get.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service_interface.dart';
import 'package:quizzical/features/quiz/presentation/controllers/quiz_controller.dart';
import '../../../../di_container.dart';

class QuizPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController(quizServiceInterface: sl<QuizServiceInterface>()));
  }
}