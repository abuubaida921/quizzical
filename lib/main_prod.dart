import 'dart:async';
import 'package:flutter/material.dart';
import 'main_common.dart' as bootstrap;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  await bootstrap.mainCommon(environment: 'prod');
}