import 'package:get/get.dart';
import 'package:quizzical/features/quiz/presentation/controllers/quiz_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/quiz_trivia_remote_data_source.dart';

class QuizPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());

    Get.lazyPut(() => QuizTriviaRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => QuizController(Get.find<QuizTriviaRemoteDataSource>()));
  }
}