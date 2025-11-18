import 'package:get/get.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/splash/presentation/pages/welcome_page.dart';

class AppPages {
  static const splash = '/splash';
  static const welcome = '/welcome';

  static final routes = [
    GetPage(name: AppPages.splash, page: () => const SplashPage()),
    GetPage(name: AppPages.welcome, page: () => const WelcomePage()),
  ];
}