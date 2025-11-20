import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_text_style.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Center(
                child: Image.asset(Assets.assetIcons.celebrate,width: 350,),
              ),

              const SizedBox(height: 8),

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

              const SizedBox(height: 20),

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

              Spacer(),

              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed(AppPages.categories);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF066A66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'PLAY AGAIN',
                    style: AppTextStyles.button.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
