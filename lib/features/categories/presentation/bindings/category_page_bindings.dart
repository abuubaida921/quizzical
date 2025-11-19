import 'package:get/get.dart';
import 'package:quizzical/features/categories/domain/services/category_service_interface.dart';
import '../controllers/category_controller.dart';
import '../../../../di_container.dart';

class CategoryPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController(categoryServiceInterface: sl<CategoryServiceInterface>()));
  }
}