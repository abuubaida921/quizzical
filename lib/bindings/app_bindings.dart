import 'package:get/get.dart';
import '../core/network/api_client.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient());
  }
}