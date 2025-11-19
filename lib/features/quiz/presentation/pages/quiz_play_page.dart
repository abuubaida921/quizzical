import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/quiz_controller.dart';
import '../../../../routes/app_pages.dart';
import '../widgets/exit_quiz_dialogue.dart';

class QuizPlayPage extends GetView<QuizController> {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Obx(
                        () => Text(
                      controller.progressText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final shouldExit = await Get.dialog<bool>(
                        const ExitQuizDialog(),
                        barrierDismissible: false,
                      );
                      if (shouldExit == true) {
                        // Clear quiz state and go back to categories/home as appropriate
                        controller.resetProgress(clearQuestions: true);
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
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: 0.6,
                            ),
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
                final q = controller.currentQuestion;
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (q == null) {
                  return SizedBox(
                    height: 160,
                    child: Center(
                      child: Text(
                        'No question available',
                        style: theme.textTheme.titleMedium,
                      ),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            // Options area (handles boolean specially)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final q = controller.currentQuestion;
                  if (q == null) return const SizedBox.shrink();

                  final showingFeedback = controller.showAnswerFeedback.value;
                  final selected = controller.selectedAnswer.value;
                  final options = controller.shuffledAnswersForCurrent();

                  // Boolean question: render two larger buttons (True/False)
                  if (q.type.toLowerCase() == 'boolean') {
                    // Normalize expected options to be readable (True/False)
                    final displayOptions = <String>['True', 'False']
                        .where((v) => options.map((o) => o.toLowerCase()).contains(v.toLowerCase()))
                        .toList();
                    final useOptions = displayOptions.isNotEmpty ? displayOptions : options;

                    return Column(
                      children: [
                        const SizedBox(height: 6),
                        LayoutBuilder(builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 420;
                          if (isWide) {
                            return Row(
                              children: useOptions.map((opt) {
                                final isSelected = selected != null && _normalize(selected) == _normalize(opt);
                                final isCorrect = _normalize(opt) == _normalize(q.correctAnswer);
                                Color bg = Colors.white;
                                Widget trailing = _EmptyRadio();

                                if (showingFeedback) {
                                  if (isCorrect) {
                                    bg = const Color(0xFFBFEFDC);
                                    trailing = _ResultCircle(color: const Color(0xFF0E6F66), icon: Icons.check, iconColor: Colors.white);
                                  } else if (isSelected && !isCorrect) {
                                    bg = const Color(0xFFF6BFC0);
                                    trailing = _ResultCircle(color: const Color(0xFFD64555), icon: Icons.close, iconColor: Colors.white);
                                  }
                                }

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                    child: _OptionTile(
                                      text: opt,
                                      backgroundColor: bg,
                                      trailing: trailing,
                                      onTap: () {
                                        if (!showingFeedback) controller.submitAnswer(opt);
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return Column(
                              children: useOptions.map((opt) {
                                final isSelected = selected != null && _normalize(selected) == _normalize(opt);
                                final isCorrect = _normalize(opt) == _normalize(q.correctAnswer);
                                Color bg = Colors.white;
                                Widget trailing = _EmptyRadio();

                                if (showingFeedback) {
                                  if (isCorrect) {
                                    bg = const Color(0xFFBFEFDC);
                                    trailing = _ResultCircle(color: const Color(0xFF0E6F66), icon: Icons.check, iconColor: Colors.white);
                                  } else if (isSelected && !isCorrect) {
                                    bg = const Color(0xFFF6BFC0);
                                    trailing = _ResultCircle(color: const Color(0xFFD64555), icon: Icons.close, iconColor: Colors.white);
                                  }
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _OptionTile(
                                    text: opt,
                                    backgroundColor: bg,
                                    trailing: trailing,
                                    onTap: () {
                                      if (!showingFeedback) controller.submitAnswer(opt);
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                      ],
                    );
                  }

                  // Default multiple-choice layout
                  return ListView.separated(
                    itemCount: options.length,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final option = options[idx];
                      final isSelected = selected != null && _normalize(selected) == _normalize(option);
                      final isCorrect = _normalize(option) == _normalize(q.correctAnswer);

                      Color bg = Colors.white;
                      Widget trailing = _EmptyRadio();

                      if (showingFeedback) {
                        if (isCorrect) {
                          bg = const Color(0xFFBFEFDC);
                          trailing = _ResultCircle(color: const Color(0xFF0E6F66), icon: Icons.check, iconColor: Colors.white);
                        } else if (isSelected && !isCorrect) {
                          bg = const Color(0xFFF6BFC0);
                          trailing = _ResultCircle(color: const Color(0xFFD64555), icon: Icons.close, iconColor: Colors.white);
                        }
                      }

                      return _OptionTile(
                        text: option,
                        backgroundColor: bg,
                        trailing: trailing,
                        onTap: () {
                          if (!showingFeedback) {
                            controller.submitAnswer(option);
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
                  final showingFeedback = controller.showAnswerFeedback.value;
                  final hasSelected = controller.selectedAnswer.value != null || showingFeedback;
                  return ElevatedButton(
                    onPressed: hasSelected ? () => controller.nextQuestion() : null,
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
  String _normalize(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
}

/// Option tile - rounded white card with text and trailing widget (radio/check/etc).
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
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
  const _EmptyRadio({super.key});

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

  const _ResultCircle({super.key, required this.color, required this.icon, required this.iconColor});

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