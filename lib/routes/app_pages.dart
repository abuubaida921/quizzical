import 'package:get/get.dart';
import 'package:quizzical/features/categories/presentation/pages/category_page.dart';
import 'package:quizzical/features/quiz/presentation/pages/results_page.dart';
import '../features/categories/presentation/bindings/category_page_bindings.dart';
import '../features/quiz/presentation/bindings/quiz_page_bindings.dart';
import '../features/quiz/presentation/pages/quiz_config_page.dart';
import '../features/quiz/presentation/pages/quiz_play_page.dart';
import '../features/splash/presentation/bindings/splash_page_binding.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/splash/presentation/pages/welcome_page.dart';

class AppPages {
  static const splash = '/splash';
  static const welcome = '/welcome';
  static const categories = '/categories';
  static const quizConfigPage = '/quiz-config';
  static const quizPlayPage = '/quiz-play';
  static const resultsPage = '/results';

  static final routes = [
    GetPage(
      name: AppPages.splash,
      page: () => const SplashPage(),
      binding: SplashPageBinding(),
    ),
    GetPage(name: AppPages.welcome, page: () => const WelcomePage()),
    GetPage(
      name: AppPages.categories,
      page: () => const CategoryPage(),
      binding: CategoryPageBindings(),
    ),
    GetPage(
      name: AppPages.quizConfigPage,
      page: () => const QuizConfigPage(),
      binding: QuizPageBindings(),
    ),
    GetPage(
      name: AppPages.quizPlayPage,
      page: () => const QuizPlayPage(),
    ),
    GetPage(
      name: AppPages.resultsPage,
      page: () => const ResultsPage(),
      binding: QuizPageBindings(),
    ),
  ];
}
