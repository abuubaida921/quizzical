import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const _illustrationPath = 'assets/images/welcome_illustration.png';
  static const _primaryButtonColor = Color(0xFF0F7B71);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 28),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.45,
                        maxWidth: constraints.maxWidth * 0.85,
                      ),
                      child: _buildIllustration(context),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Quizzical',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/categories');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.18),
                    ),
                    child: Text(
                      'GET STARTED',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Image.asset(
        _illustrationPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: constraints.maxWidth * 0.6,
                  height: constraints.maxWidth * 0.6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 72,
                      color: Color(0xFF6C4DF5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}