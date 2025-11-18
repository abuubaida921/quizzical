import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cherry_toast/cherry_toast.dart';

class ToastUtil {
  ToastUtil._();

  static const Duration _defaultDuration = Duration(seconds: 3);

  static void success(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
    bool showCloseButton = false,
  }) {
    _showWithCherry(
      context,
      () => CherryToast.success(
        title: Text(title ?? 'Success'),
        description: Text(message),
        toastDuration: duration ?? _defaultDuration,
        displayCloseButton: showCloseButton,
      ).show(context),
      message,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
    bool showCloseButton = true,
  }) {
    _showWithCherry(
      context,
      () => CherryToast.error(
        title: Text(title ?? 'Error'),
        description: Text(message),
        toastDuration: duration ?? _defaultDuration,
        displayCloseButton: showCloseButton,
      ).show(context),
      message,
    );
  }

  static void info(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
    bool showCloseButton = false,
  }) {
    _showWithCherry(
      context,
      () => CherryToast.info(
        title: Text(title ?? 'Info'),
        description: Text(message),
        toastDuration: duration ?? _defaultDuration,
        displayCloseButton: showCloseButton,
      ).show(context),
      message,
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    String? title,
    Duration? duration,
    bool showCloseButton = false,
  }) {
    _showWithCherry(
      context,
      () => CherryToast.warning(
        title: Text(title ?? 'Warning'),
        description: Text(message),
        toastDuration: duration ?? _defaultDuration,
        displayCloseButton: showCloseButton,
      ).show(context),
      message,
    );
  }

  static void custom(
    BuildContext context,
    VoidCallback cherryToastCall,
    String fallbackMessage,
  ) {
    _showWithCherry(context, cherryToastCall, fallbackMessage);
  }

  static void _showWithCherry(BuildContext context, VoidCallback showCall, String fallbackMessage) {
    try {
      showCall();
    } catch (e, st) {
      if (kDebugMode) {
        print('CherryToast failed: $e\n$st');
      }

      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(fallbackMessage),
            duration: _defaultDuration,
          ),
        );
      } catch (e2) {
        if (kDebugMode) {
          print('ScaffoldMessenger fallback failed: $e2');
        }
      }
    }
  }
}

