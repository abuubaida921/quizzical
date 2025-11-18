import 'package:get/get.dart';
import '../core/network/api_client.dart';
import '../features/categories/data/datasources/trivia_remote_datasource.dart';
import '../features/categories/presentation/controllers/category_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());

    Get.lazyPut(() => TriviaRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => CategoryController(Get.find<TriviaRemoteDataSource>()));
  }
}