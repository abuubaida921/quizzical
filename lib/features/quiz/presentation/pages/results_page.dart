import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/quiz_controller.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late final QuizController _controller;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<QuizController>();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // small stagger: play confetti animation when page opens
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int _percentage() {
    final total = max(1, _controller.questions.length);
    final p = (_controller.score.value / total) * 100;
    return p.round();
  }

  String _headline() {
    final percent = _percentage();
    if (percent >= 90) return 'Excellent!';
    if (percent >= 75) return 'Congratulation';
    if (percent >= 50) return 'Good Job';
    return 'Keep Trying';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 18),

              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(Assets.assetIcons.celebrate,width: 250,),
                ),
              ),

              // Headline
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      _headline(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading1.copyWith(color: Colors.black,fontSize: 28),

                    ),
                    const SizedBox(height: 18),

                    // Score pill with double-layer effect
                    _ScoreBadge(percentage: _percentage()),
                    const SizedBox(height: 18),

                    // Supporting text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        "You've got a great foundation. Ready to try a different category?",
                        textAlign: TextAlign.center,
                          style: AppTextStyles.heading3.copyWith(color: Colors.black)
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // reset quiz state and navigate back to categories
                      try {
                        _controller.questions.clear();
                        _controller.currentIndex.value = 0;
                        _controller.score.value = 0;
                        _controller.selectedAnswer.value = null;
                        _controller.showAnswerFeedback.value = false;
                      } catch (_) {}

                      Get.offAllNamed('/categories');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF066A66), // teal-ish
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.18),
                    ),
                    child: Text('PLAY AGAIN', style: AppTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),),
                  ),
                ),
              ),
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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.resultScoreOuterColor.withAlpha(47),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.resultScoreOuterColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.resultScoreInnerColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '$percentage%',
                style: AppTextStyles.heading1.copyWith(color: AppColors.categoryTitlePrimary)
            ),
          ),
        ),
      ),
    );
  }
}
