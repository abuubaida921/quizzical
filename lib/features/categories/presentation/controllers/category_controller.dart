import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/helper/api_checker.dart';
import '../../../../data/datasource/model/api_response.dart';
import '../../data/models/category_model.dart';
import '../../domain/services/category_service_interface.dart';

class CategoryController extends GetxController {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  var categorySelectedIndex = 0.obs;
  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList =>_categoryList;

  final isLoading = false.obs;

  Future<void> getFeaturedDealList() async {
    isLoading.value=true;
    _categoryList =[];
    ApiResponse apiResponse = await categoryServiceInterface?.getCategoryList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200 && apiResponse.response!.data.toString() != '{}') {
      _categoryList =[];
      apiResponse.response!.data.forEach((cData) => _categoryList?.add(CategoryModel.fromJson(cData)));
      categorySelectedIndex.value = 0;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    isLoading.value=false;
  }

  void changeSelectedIndex(int selectedIndex) {
    categorySelectedIndex.value = selectedIndex;
  }

  /// Called when the user taps a category card.
  /// Navigates to the quiz configuration page and passes category id & name as arguments.
  void selectCategory(CategoryModel category) {
    Get.toNamed(AppPages.quizConfigPage, arguments: {
      'categoryId': category.id,
      'categoryName': category.name,
    });
  }
}