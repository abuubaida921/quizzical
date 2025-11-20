import 'dart:io';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/app_config.dart';
import 'di_container.dart' as di;

Future<void> mainCommon({required String environment}) async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  AppConfig.instance.setEnvironment(environment);
  runApp(const App());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}