import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/routes/app_pages.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            Get.offAllNamed(AppPages.categories);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBtnBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            shadowColor: Colors.black.withOpacity(0.18),
          ),
          child: Text(
            'GET STARTED',
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}