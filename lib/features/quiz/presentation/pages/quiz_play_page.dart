import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../controllers/quiz_play_controller.dart';
import '../widgets/exit_quiz_dialogue.dart';

class QuizPlayPage extends StatelessWidget {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizPlayController ctrl = Get.put(QuizPlayController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            final exit = await Get.dialog(
              const ExitQuizDialog(),
              barrierDismissible: false,
            );
            if (exit == true) Get.offAllNamed(AppPages.categories);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          final shouldExit = await Get.dialog<bool>(
                            const ExitQuizDialog(),
                            barrierDismissible: false,
                          );
                          if (shouldExit == true) {
                            Get.offAllNamed(AppPages.categories);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'EXIT',
                              style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            Image.asset(
                              Assets.assetIcons.logout,
                              width: 25,
                              height: 25,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Obx(() => Text(
                      ctrl.progressText,
                      style: AppTextStyles.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final q = ctrl.currentQuestion;
                  return Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Text(
                      q.question,
                      style: AppTextStyles.heading3
                          .copyWith(color: Colors.black),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    final options = ctrl.currentOptions;
                    final selected = ctrl.selectedAnswer.value;
                    final showing = ctrl.showFeedback.value;
                    final correct = ctrl.currentQuestion.correctAnswer;

                    return ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (ctx, i) {
                        final opt = options[i];
                        final isSelected =
                            ctrl.normalize(selected) == ctrl.normalize(opt);
                        final isCorrect =
                            ctrl.normalize(opt) ==
                                ctrl.normalize(correct);

                        Color bg = Colors.white;
                        Widget indicator = const _EmptyRadio();

                        if (showing) {
                          if (isCorrect) {
                            bg = AppColors.rightAnsBgColor;
                            indicator = const _ResultCircle(
                                color: AppColors.nextBtnBgColor,
                                icon: Icons.check,
                                iconColor: Colors.white);
                          } else if (isSelected && !isCorrect) {
                            bg = AppColors.wrongAnsBgColor;
                            indicator = const _ResultCircle(
                                color: Colors.red,
                                icon: Icons.close,
                                iconColor: Colors.white);
                          }
                        }

                        return _OptionTile(
                          text: opt,
                          backgroundColor: bg,
                          trailing: indicator,
                          onTap: () {
                            if (!showing) ctrl.submitAnswer(opt);
                          },
                        );
                      },
                    );
                  }),
                ),
              ),

              Obx(() {
                final canTap = ctrl.showFeedback.value;
                return PrimaryButtonWidget(
                  title: "Next",
                  onPressed: canTap ? ctrl.next : null,
                  isEnabled: canTap,
                  height: 55,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}


class _OptionTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget trailing;

  const _OptionTile({
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 6)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.heading3.copyWith(
                      color: Colors.black, fontSize: 15),
                ),
              ),
              trailing
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyRadio extends StatelessWidget {
  const _EmptyRadio();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 1.6),
      ),
      margin: const EdgeInsets.only(left: 12),
    );
  }
}

class _ResultCircle extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _ResultCircle({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
