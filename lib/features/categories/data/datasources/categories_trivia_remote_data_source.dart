import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';

class CategoriesTriviaRemoteDataSource {
  final ApiClient client;
  CategoriesTriviaRemoteDataSource(this.client);

  Future<List<CategoryModel>> fetchCategories() async {
    final res = await client.get('/api_category.php');

    if (res == null) {
      throw Exception('Empty response from categories endpoint');
    }

    try {
      final dynamicList = res['trivia_categories'];
      if (dynamicList is! List) {
        throw FormatException('Invalid categories payload');
      }

      final categories = dynamicList
          .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      return categories;
    } catch (e, st) {
      if (kDebugMode) {
        print('Error parsing categories: $e\n$st');
      }
      rethrow;
    }
  }
}