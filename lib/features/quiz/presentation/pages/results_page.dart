import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../widgets/score_badge_widget.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  int _percentage(int score, int total) {
    final t = max(1, total);
    final p = (score / t) * 100;
    return p.round();
  }

  String _headline(int percent) {
    if (percent >= 90) return "Excellent!";
    if (percent >= 75) return "Congratulation";
    if (percent >= 50) return "Good Job!";
    return "Keep Trying!";
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final int score = args["score"] ?? 0;
    final int total = args["total"] ?? 1;

    final percent = _percentage(score, total);
    final title = _headline(percent);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Center(
                    child: Image.asset(Assets.assetIcons.celebrate,width: 300,),
                  ),

                  const SizedBox(height: 50),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ScoreBadge(percentage: percent),

                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "You've got a great foundation. Ready to try a different category?",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            PrimaryButtonWidget(
              title: "PLAY AGAIN",
              onPressed: () => Get.offAllNamed(AppPages.categories),
            ),
          ],
        ),
      ),
    );
  }
}
