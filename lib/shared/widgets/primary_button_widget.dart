import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double height;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final Color? disabledColor;
  final TextStyle? textStyle;

  const PrimaryButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.isEnabled = true,
    this.height = 58,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 22),
    this.radius = 20,
    this.color,
    this.disabledColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? AppColors.primaryBtnBgColor,
            disabledBackgroundColor:
            disabledColor ?? Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.18),
          ),
          child: Text(
            title,
            style: textStyle ?? AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}