import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service_interface.dart';
import '../../../../core/helper/api_checker.dart';
import '../../../../core/utils/toast_util.dart';
import '../../../../data/datasource/model/api_response.dart';
import '../../../../routes/app_pages.dart';
import '../../domain/models/quiz_model.dart';

class QuizController extends GetxController {
  final QuizServiceInterface? quizServiceInterface;
  QuizController({required this.quizServiceInterface});

  // State
  final isLoading = false.obs;

  List<QuestionModel>? _questionList;
  List<QuestionModel>? get questionList =>_questionList;

  Future<void> loadQuizList({
    required int amount,
    required int categoryId,
    String difficulty = 'any',
    String type = 'any',
  }) async {
    try {
      isLoading.value = true;
      _questionList = [];
      ApiResponse apiResponse = await quizServiceInterface?.getQuizList(
          amount: amount, categoryId: categoryId,difficulty: difficulty,type: type);
      if (apiResponse.response != null &&
          apiResponse.response!.statusCode == 200) {
        _questionList = [];
        if(apiResponse.response!.data['response_code'].toString() != '0'){
          ToastUtil.error(Get.context!, 'No questions available for the selected configuration.');
        }else {
          apiResponse.response!.data['results'].forEach((cData) =>
              _questionList?.add(QuestionModel.fromJson(cData)));
          Get.offNamed(AppPages.quizPlayPage);
        }
      } else {
        ApiChecker.checkApi(apiResponse);
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }finally {
      isLoading.value = false;
    }
  }
}