import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/categories_trivia_remote_data_source.dart';
import '../controllers/category_controller.dart';

class CategoryPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());

    Get.lazyPut(() => CategoriesTriviaRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => CategoryController(Get.find<CategoriesTriviaRemoteDataSource>()));
  }
}