import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app_config.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController with SingleGetTickerProviderMixin {
  late final AnimationController animController;
  late final Animation<double> scaleAnim;
  late final Animation<double> fadeAnim;

  Timer? _navTimer;

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeOutBack),
    );
    fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animController, curve: Curves.easeIn),
    );
    animController.forward();
    _navTimer = Timer(const Duration(milliseconds: 1800), () {
      Get.offNamed(AppPages.welcome);
    });
  }

  @override
  void onClose() {
    _navTimer?.cancel();
    animController.dispose();
    super.onClose();
  }

  String get flavorLabel {
    try {
      final env = AppConfig.instance.environment;
      return env.isNotEmpty ? env.toUpperCase() : '';
    } catch (_) {
      return '';
    }
  }
}