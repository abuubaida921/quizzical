import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

DropdownMenuItem<String> dropDownItemWidget(String value, String label) {
  return DropdownMenuItem(
    value: value,
    child: Text(label, style: AppTextStyles.bodySmall),
  );
}