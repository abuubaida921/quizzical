import 'package:quizzical/features/categories/domain/repositories/category_repository_interface.dart';
import 'package:quizzical/features/categories/domain/services/category_service_interface.dart';

class CategoryService implements CategoryServiceInterface{
  CategoryRepositoryInterface categoryRepositoryInterface;
  CategoryService({required this.categoryRepositoryInterface});

  @override
  Future<dynamic> getCategoryList() async {
    return await categoryRepositoryInterface.getCategoryList();
  }

}