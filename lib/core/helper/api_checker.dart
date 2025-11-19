import 'dart:developer';

import 'package:get/get.dart';
import 'package:quizzical/core/utils/toast_util.dart';

import '../../data/datasource/model/api_response.dart';
import '../../data/datasource/model/error_response.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse, {bool firebaseResponse = false}) {

    dynamic errorResponse = apiResponse.error is String ? apiResponse.error :  ErrorResponse.fromJson(apiResponse.error);
    if(apiResponse.error == "Failed to load data - status code: 401") {
    }else if(apiResponse.response?.statusCode == 500){
      ToastUtil.error(Get.context!, 'Internal server error');
    }else if(apiResponse.response?.statusCode == 503){
      ToastUtil.error(Get.context!, apiResponse.response?.data['message']);
    }else {
      log("==ffError=>${apiResponse.error}");
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        log(errorResponse.toString());
      }
      ToastUtil.error(Get.context!, errorMessage);
    }
  }


  static ErrorResponse getError(ApiResponse apiResponse){
    ErrorResponse error;

    try{
      error = ErrorResponse.fromJson(apiResponse.response?.data);
    }catch(e){
      if(apiResponse.error is String){
        error = ErrorResponse(errors: [Errors(code: '', message: apiResponse.error.toString())]);

      }else{
        error = ErrorResponse.fromJson(apiResponse.error);
      }
    }
    return error;
  }
}