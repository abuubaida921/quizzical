import 'package:flutter/material.dart';
import 'package:quizzical/core/constants/app_constants.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../widgets/illustration_widget.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 50),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.45,
                  maxWidth: constraints.maxWidth * 0.85,
                ),
                child: buildIllustration(context),
              ),
              const SizedBox(height: 22),
              Text(
                AppConstants.appName,
                style: AppTextStyles.appTitle,
              ),
              Spacer(),
              PrimaryButtonWidget(
                title: "START QUIZ",
                onPressed: () => Get.offAllNamed(AppPages.categories),
              )
            ],
          );
        }),
      ),
    );
  }
}