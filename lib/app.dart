import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/app_bindings.dart';
import 'routes/app_pages.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quizzical',
      debugShowCheckedModeBanner: false,

      // Initial dependency bindings
      initialBinding: AppBindings(),

      // Routing
      initialRoute: AppPages.splash,
      getPages: AppPages.routes,

      // Theme design
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
      ),

      // Fallback in case of unknown route
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => Scaffold(
          appBar: AppBar(title: const Text('Not found')),
          body: const Center(child: Text('Page not found')),
        ),
      ),
    );
  }
}