import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_text_style.dart';

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

              Expanded(
                flex: 3,
                child: Center(
                  child: Image.asset(Assets.assetIcons.celebrate,width: 250,),
                ),
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

              const SizedBox(height: 14),

              _ScoreBadge(percentage: percent),

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

              const SizedBox(height: 30),

              SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/categories');
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

class _ScoreBadge extends StatelessWidget {
  final int percentage;
  const _ScoreBadge({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.resultScoreOuterColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.resultScoreOuterColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
          decoration: BoxDecoration(
            color: AppColors.resultScoreInnerColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '$percentage%',
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.categoryTitlePrimary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
