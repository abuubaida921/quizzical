import 'package:flutter/cupertino.dart';

import 'main_common.dart' as bootstrap;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  await bootstrap.mainCommon(environment: 'dev');
}