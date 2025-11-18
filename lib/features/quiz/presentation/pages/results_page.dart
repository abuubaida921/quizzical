import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/assets.dart';
import '../controllers/quiz_controller.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> with SingleTickerProviderStateMixin {
  late final QuizController _controller;
  late final AnimationController _animController;
  late final Animation<double> _confettiAnim;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<QuizController>();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _confettiAnim = CurvedAnimation(parent: _animController, curve: Curves.elasticOut);

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

              // Top illustration (confetti / party popper)
              Expanded(
                flex: 3,
                child: Center(
                  child: ScaleTransition(
                    scale: _confettiAnim,
                    child: _buildTopIllustration(context),
                  ),
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
                      // style: theme.textTheme.headline5?.copyWith(
                      //   fontSize: 28,
                      //   fontWeight: FontWeight.w700,
                      //   color: Colors.grey[850],
                      // ),
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
                        // style: theme.textTheme.bodyText2?.copyWith(
                        //   fontSize: 15,
                        //   color: Colors.grey[800],
                        //   height: 1.4,
                        //   fontWeight: FontWeight.w500,
                        // ),
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
                  height: 66,
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.18),
                    ),
                    child: Text(
                      'PLAY AGAIN',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIllustration(BuildContext context) {
    // Try to render a party illustration from assets; fallback to a stylized placeholder.
    return LayoutBuilder(builder: (context, constraints) {
      final maxHeight = constraints.maxHeight * 0.75;
      final assetPath = Assets.assetImages.emptyState; // replace with a party/celebration asset if available

      return Image.asset(
        assetPath,
        height: maxHeight,
        fit: BoxFit.contain,
        errorBuilder: (context, error, st) {
          // Fallback: stylized party popper with simple confetti shapes
          return SizedBox(
            height: maxHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.rotate(
                  angle: -pi / 8,
                  child: Container(
                    width: maxHeight * 0.55,
                    height: maxHeight * 0.55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE3F0),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: maxHeight * 0.05,
                  child: Icon(
                    Icons.celebration_rounded,
                    size: maxHeight * 0.38,
                    color: const Color(0xFFEF6C90),
                  ),
                ),
                // simple confetti dots
                Positioned(
                  top: 8,
                  left: 32,
                  child: _ConfettiDot(color: Colors.green, size: 14),
                ),
                Positioned(
                  top: 28,
                  right: 48,
                  child: _ConfettiDot(color: Colors.blue, size: 12),
                ),
                Positioned(
                  bottom: 24,
                  left: 48,
                  child: _ConfettiDot(color: Colors.amber, size: 12),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class _ConfettiDot extends StatelessWidget {
  final Color color;
  final double size;
  const _ConfettiDot({Key? key, required this.color, this.size = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 3))
      ]),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int percentage;
  const _ScoreBadge({Key? key, required this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final innerColor = const Color(0xFF86E6B3); // mint green
    final outerColor = const Color(0xFFEAF9EE); // pale green backdrop
    final textColor = Colors.grey[900];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: outerColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6))
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: innerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}