import '../../../../core/interface/repo_interface.dart';

abstract class CategoryRepositoryInterface implements RepositoryInterface{
  Future<dynamic> getCategoryList();
}