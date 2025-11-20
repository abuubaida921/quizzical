import 'package:flutter/foundation.dart';
import 'package:quizzical/features/quiz/domain/repositories/quiz_repository_interface.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/datasource/model/api_response.dart';
import '../../../../data/datasource/remote/dio/dio_client.dart';
import '../../../../data/datasource/remote/exception/api_error_handler.dart';

class QuizRepository implements QuizRepositoryInterface{
  final DioClient? dioClient;
  QuizRepository({required this.dioClient});

  @override
  Future<ApiResponse> getQuizList({
    required int amount,
    required int categoryId,
    String? difficulty,
    String? type,
  }) async {
    try {
      final queryParams = {
        'amount': amount.toString(),
        'category': categoryId.toString(),
        if (difficulty != null && difficulty != 'any') 'difficulty': difficulty,
        if (type != null && type != 'any') 'type': type,
        'encode':'base64'
      };
      final uri = Uri.parse(AppConstants.quizListUri)
          .replace(queryParameters: queryParams);

      if (kDebugMode) {
        print("FULL URL IS: $uri");
      }

      final response = await dioClient!.get(
        AppConstants.quizListUri,
        queryParameters: queryParams,
      );

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


}