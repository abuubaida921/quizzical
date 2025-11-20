import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

class ScoreBadge extends StatelessWidget {
  final int percentage;
  const ScoreBadge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
      ),
    );
  }
}