import 'package:get/get.dart';
import 'package:quizzical/features/splash/presentation/controllers/splash_controller.dart';

class SplashPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(
      SplashController(),
    );
  }
}