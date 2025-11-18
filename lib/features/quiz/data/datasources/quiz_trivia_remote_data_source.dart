import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../models/quiz_model.dart';

class QuizTriviaRemoteDataSource {
  final ApiClient client;
  QuizTriviaRemoteDataSource(this.client);

  Future<List<QuestionModel>> fetchQuestions({
    required int amount,
    required int categoryId,
    String difficulty = 'any',
    String type = 'any',
  }) async {

    final Map<String, String> query = {
      'amount': amount.toString(),
    };

    if (categoryId > 0) {
      query['category'] = categoryId.toString();
    }
    if (difficulty.isNotEmpty && difficulty.toLowerCase() != 'any') {
      query['difficulty'] = difficulty.toLowerCase();
    }
    if (type.isNotEmpty && type.toLowerCase() != 'any') {
      query['type'] = type.toLowerCase();
    }

    try {
      final res = await client.get('/api.php', queryParameters: query);

      if (res == null) {
        throw Exception('Empty response from trivia API');
      }

      if (res is Map<String, dynamic>) {
        final responseCode = res['response_code'];
        final results = res['results'];

        if (responseCode != 0) {
          throw Exception('Trivia API response_code: $responseCode');
        }

        if (results is! List) {
          throw FormatException('Unexpected trivia results format');
        }

        final questions = results.map<QuestionModel>((item) {
          if (item is Map<String, dynamic>) {
            return QuestionModel.fromJson(item);
          } else if (item is Map) {
            return QuestionModel.fromJson(Map<String, dynamic>.from(item));
          } else {
            throw FormatException('Unsupported question item type: ${item.runtimeType}');
          }
        }).toList();

        return questions;
      } else {
        throw FormatException('Unexpected trivia API payload type: ${res.runtimeType}');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('fetchQuestions error: $e\n$st');
      }
      rethrow;
    }
  }
}