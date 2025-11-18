import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../controllers/quiz_controller.dart';
import '../widgets/exit_quiz_dialogue.dart';

class QuizPlayPage extends StatelessWidget {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController ctrl = Get.find<QuizController>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: progress + exit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                children: [
                  const Spacer(),
                  Obx(() => Text(
                    ctrl.progressText,
                  )),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      // Show the dialog and handle result
                      final shouldExit = await Get.dialog<bool>(
                        const ExitQuizDialog(),
                        barrierDismissible: false,
                      );

                      if (shouldExit == true) {
                        Get.offAllNamed(AppPages.categories);
                      }
                    },
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'EXIT',
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.exit_to_app_outlined, color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // Question card area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                final q = ctrl.currentQuestion;
                if (ctrl.isLoading.value) {
                  return SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (q == null) {
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: Text('No question available',)
                    ),
                  );
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8))
                    ],
                  ),
                  child: Text(
                    q.question,
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            // Options list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final q = ctrl.currentQuestion;
                  if (q == null) return const SizedBox.shrink();

                  final options = ctrl.shuffledAnswersForCurrent();
                  final selected = ctrl.selectedAnswer.value;
                  final showingFeedback = ctrl.showAnswerFeedback.value;

                  return ListView.separated(
                    itemCount: options.length,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final option = options[idx];
                      final normalizedOption = option;
                      final isSelected = selected != null && _normalize(selected) == _normalize(normalizedOption);
                      final isCorrect = _normalize(option) == _normalize(q.correctAnswer);

                      // Determine colors and icon state
                      Color bg = Colors.white;
                      Widget trailing = _EmptyRadio(); // hollow circle in mock

                      if (showingFeedback) {
                        if (isCorrect) {
                          bg = const Color(0xFFBFEFDC); // mint green for correct
                          trailing = _ResultCircle(
                            color: const Color(0xFF0E6F66),
                            icon: Icons.check,
                            iconColor: Colors.white,
                          );
                        } else if (isSelected && !isCorrect) {
                          bg = const Color(0xFFF6BFC0); // pale red for incorrect
                          trailing = _ResultCircle(
                            color: const Color(0xFFD64555),
                            icon: Icons.close,
                            iconColor: Colors.white,
                          );
                        } else {
                          bg = Colors.white;
                          trailing = _EmptyRadio();
                        }
                      } else {
                        if (isSelected) {
                          // subtle selected state before feedback
                          bg = Colors.white;
                          trailing = _EmptyRadio();
                        } else {
                          bg = Colors.white;
                          trailing = _EmptyRadio();
                        }
                      }

                      return _OptionTile(
                        text: option,
                        backgroundColor: bg,
                        trailing: trailing,
                        onTap: () {
                          if (!showingFeedback) {
                            ctrl.submitAnswer(option);
                          }
                        },
                      );
                    },
                  );
                }),
              ),
            ),

            // Bottom Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
              child: SizedBox(
                height: 66,
                width: double.infinity,
                child: Obx(() {
                  final showingFeedback = ctrl.showAnswerFeedback.value;
                  // If no selection yet, keep Next disabled (encourage answer selection)
                  final hasSelected = ctrl.selectedAnswer.value != null || showingFeedback;
                  return ElevatedButton(
                    onPressed: hasSelected ? () => ctrl.nextQuestion() : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E5E59),
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(
                      'Next',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Local normalizer (same logic used in the controller) to compare strings consistently.
  String _normalize(String s) {
    return s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
  }
}

/// Option tile - rounded white card with text and trailing widget (radio/check/etc).
class _OptionTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget trailing;

  const _OptionTile({
    Key? key,
    required this.text,
    required this.onTap,
    required this.backgroundColor,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 6))
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
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Hollow radio circle (when no feedback shown)
class _EmptyRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 1.6),
      ),
      margin: const EdgeInsets.only(left: 12),
    );
  }
}

/// Small circular result indicator with icon (used for correct/incorrect)
class _ResultCircle extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _ResultCircle({Key? key, required this.color, required this.icon, required this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}