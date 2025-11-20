import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzical/features/categories/domain/repositories/category_repository.dart';
import 'package:quizzical/features/categories/domain/repositories/category_repository_interface.dart';
import 'package:quizzical/features/categories/domain/services/category_service.dart';
import 'package:quizzical/features/categories/domain/services/category_service_interface.dart';
import 'package:quizzical/features/categories/presentation/controllers/category_controller.dart';
import 'package:quizzical/features/quiz/domain/repositories/quiz_repository_interface.dart';
import 'package:quizzical/features/quiz/domain/services/quiz_service.dart';

import 'core/constants/app_constants.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'features/quiz/domain/repositories/quiz_repository.dart';
import 'features/quiz/domain/services/quiz_service_interface.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(),));

  // Repository
  sl.registerLazySingleton(() => CategoryRepository(dioClient: sl()));

  // Provider
  sl.registerFactory(() => CategoryController(categoryServiceInterface: sl()));

  //interface
  CategoryRepositoryInterface categoryRepositoryInterface = CategoryRepository(dioClient: sl());
  sl.registerLazySingleton(() => categoryRepositoryInterface);
  CategoryServiceInterface categoryServiceInterface = CategoryService( categoryRepositoryInterface: sl());
  sl.registerLazySingleton(() => categoryServiceInterface);

  QuizRepositoryInterface quizRepositoryInterface = QuizRepository(dioClient: sl());
  sl.registerLazySingleton(() => quizRepositoryInterface);
  QuizServiceInterface quizServiceInterface = QuizService( quizRepositoryInterface: sl());
  sl.registerLazySingleton(() => quizServiceInterface);

  //services
  sl.registerLazySingleton(() => CategoryService( categoryRepositoryInterface: sl()));
}
