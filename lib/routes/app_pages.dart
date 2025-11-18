import 'package:get/get.dart';
import 'package:quizzical/features/categories/presentation/pages/category_page.dart';
import '../features/categories/data/datasources/categories_trivia_remote_data_source.dart';
import '../features/categories/presentation/controllers/category_controller.dart';
import '../features/quiz/data/datasources/quiz_trivia_remote_data_source.dart';
import '../features/quiz/presentation/controllers/quiz_controller.dart';
import '../features/quiz/presentation/pages/quiz_config_page.dart';
import '../features/quiz/presentation/pages/quiz_play_page.dart';
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
    GetPage(name: AppPages.splash, page: () => const SplashPage()),
    GetPage(name: AppPages.welcome, page: () => const WelcomePage()),
    GetPage(
      name: AppPages.categories,
      page: () => const CategoryPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CategoriesTriviaRemoteDataSource>(
          () => CategoriesTriviaRemoteDataSource(Get.find()),
          fenix: true,
        );
        Get.lazyPut<CategoryController>(
          () => CategoryController(Get.find()),
          fenix: true,
        );
      }),
    ),
    GetPage(
      name: AppPages.quizConfigPage,
      page: () => const QuizConfigPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<QuizTriviaRemoteDataSource>(
          () => QuizTriviaRemoteDataSource(Get.find()),
          fenix: true,
        );
        Get.lazyPut<QuizController>(
          () => QuizController(Get.find()),
          fenix: true,
        );
      }),
    ),
    GetPage(name: AppPages.quizPlayPage, page: () => const QuizPlayPage()),
  ];
}
