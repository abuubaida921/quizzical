import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/network_config.dart';
import '../../../../routes/app_pages.dart';

/// SplashController
/// - owns animations (vsync provided by SingleGetTickerProviderMixin)
/// - triggers navigation after a short delay
/// - exposes a simple flavorLabel getter used by the UI
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

    // start the intro animation
    animController.forward();

    // navigate to welcome after a brief delay (mirrors the original behavior)
    _navTimer = Timer(const Duration(milliseconds: 1800), () {
      // remove splash from stack and go to welcome
      Get.offNamed(AppPages.welcome);
    });
  }

  @override
  void onClose() {
    _navTimer?.cancel();
    animController.dispose();
    super.onClose();
  }

  /// Readable environment / flavor label (uppercase) or empty if none.
  String get flavorLabel {
    try {
      final env = NetworkConfig.instance.environment;
      return env.isNotEmpty ? env.toUpperCase() : '';
    } catch (_) {
      return '';
    }
  }
}