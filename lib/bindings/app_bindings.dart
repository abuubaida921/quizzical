import 'package:get/get.dart';
import '../core/network/api_client.dart';
import '../features/categories/data/datasources/categories_trivia_remote_data_source.dart';
import '../features/categories/presentation/controllers/category_controller.dart';
import '../features/quiz/data/datasources/quiz_trivia_remote_data_source.dart';
import '../features/quiz/presentation/controllers/quiz_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());

    Get.lazyPut(() => CategoriesTriviaRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => CategoryController(Get.find<CategoriesTriviaRemoteDataSource>()));

    Get.lazyPut(() => QuizTriviaRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => QuizController(Get.find<QuizTriviaRemoteDataSource>()));
  }
}