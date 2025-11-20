import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quizzical/core/theme/app_colors.dart';


class LoaderUtil {
  LoaderUtil._();

  static Widget showBeautifulLoader([Color? loaderColor]) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: loaderColor ?? AppColors.nextBtnBgColor,
        size: 40,
      ),
    );
  }
}