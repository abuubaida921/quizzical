import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../controllers/quiz_play_controller.dart';
import '../widgets/exit_quiz_dialogue.dart';

class QuizPlayPage extends StatelessWidget {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizPlayController ctrl = Get.put(QuizPlayController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Stack(
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
                          Text('EXIT',
                              style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold)),
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
                  Center(
                    child: Obx(() => Text(
                      ctrl.progressText,
                      style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold),
                    )),
                  )
                ],
              ),
            ),

            const SizedBox(height: 6),

            // --------------------
            // Question Card
            // --------------------
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
                    style: AppTextStyles.heading3.copyWith(color: Colors.black),
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            // --------------------
            // Options
            // --------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final options = ctrl.options;
                  final selected = ctrl.selectedAnswer.value;
                  final showing = ctrl.showFeedback.value;
                  final correct = ctrl.currentQuestion.correctAnswer;

                  return ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final opt = options[i];
                      final isSelected = ctrl.normalize(selected) == ctrl.normalize(opt);
                      final isCorrect = ctrl.normalize(opt) == ctrl.normalize(correct);

                      Color bg = Colors.white;
                      Widget indicator = _EmptyRadio();

                      if (showing) {
                        if (isCorrect) {
                          bg = const Color(0xFFBFEFDC);
                          indicator = const _ResultCircle(
                              color: Color(0xFF0E6F66),
                              icon: Icons.check,
                              iconColor: Colors.white);
                        } else if (isSelected && !isCorrect) {
                          bg = const Color(0xFFF6BFC0);
                          indicator = const _ResultCircle(
                              color: Color(0xFFD64555),
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

            // --------------------
            // Bottom Next Button
            // --------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: Obx(() {
                  final canTap =
                      ctrl.selectedAnswer.value.isNotEmpty ||
                          ctrl.showFeedback.value;

                  return ElevatedButton(
                    onPressed: canTap ? ctrl.next : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E5E59),
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      "Next",
                      style: AppTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ----------------------------
// UI Widgets
// ----------------------------

class _OptionTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget trailing;

  const _OptionTile({
    super.key,
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
