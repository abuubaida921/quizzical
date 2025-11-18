import 'package:get/get.dart';
import '../../data/datasources/trivia_remote_datasource.dart';
import '../../data/models/category_model.dart';

class CategoryController extends GetxController {
  final TriviaRemoteDataSource remote;
  CategoryController(this.remote);

  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      error.value = null;
      final list = await remote.fetchCategories();
      categories.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Called when the user taps a category card.
  /// Navigates to the quiz configuration page and passes category id & name as arguments.
  void selectCategory(CategoryModel category) {
    Get.toNamed('/config', arguments: {
      'categoryId': category.id,
      'categoryName': category.name,
    });
  }
}