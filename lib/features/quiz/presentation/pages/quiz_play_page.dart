import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../../../../shared/widgets/primary_button_widget.dart';
import '../controllers/quiz_play_controller.dart';
import '../widgets/empty_radio_widget.dart';
import '../widgets/exit_quiz_dialogue.dart';
import '../widgets/option_tile_widget.dart';
import '../widgets/result_circle_widget.dart';

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
                        Widget indicator = const EmptyRadioWidget();

                        if (showing) {
                          if (isCorrect) {
                            bg = AppColors.rightAnsBgColor;
                            indicator = const ResultCircleWidget(
                                color: AppColors.nextBtnBgColor,
                                icon: Icons.check,
                                iconColor: Colors.white);
                          } else if (isSelected && !isCorrect) {
                            bg = AppColors.wrongAnsBgColor;
                            indicator = const ResultCircleWidget(
                                color: Colors.red,
                                icon: Icons.close,
                                iconColor: Colors.white);
                          }
                        }

                        return OptionTileWidget(
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

