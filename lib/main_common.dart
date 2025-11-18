import 'package:flutter/material.dart';
import 'app.dart';
import 'core/network/network_config.dart';

Future<void> mainCommon({required String environment}) async {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkConfig.instance.setEnvironment(environment);
  runApp(const App());
}