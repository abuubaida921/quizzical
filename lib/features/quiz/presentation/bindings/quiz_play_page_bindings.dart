import 'package:get/get.dart';
import 'package:quizzical/features/quiz/presentation/controllers/quiz_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/quiz_trivia_remote_data_source.dart';

class QuizPlayPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());
    Get.lazyPut<QuizTriviaRemoteDataSource>(() => QuizTriviaRemoteDataSource(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<QuizController>(() => QuizController(Get.find<QuizTriviaRemoteDataSource>()), fenix: true);
  }
}