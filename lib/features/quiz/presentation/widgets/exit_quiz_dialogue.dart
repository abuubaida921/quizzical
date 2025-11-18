import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExitQuizDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String exitLabel;

  const ExitQuizDialog({
    super.key,
    this.title = 'Exit quiz?',
    this.message = 'Are you sure you want to quit the current quiz? Your progress will be lost.',
    this.cancelLabel = 'Cancel',
    this.exitLabel = 'Exit',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context, theme),
    );
  }

  Widget _buildDialogContent(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top decorative icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.exit_to_app_rounded,
                size: 36,
                color: theme.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Message
          Text(
            message,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 18),

          // Divider line
          Container(height: 1, color: Colors.grey.shade200),

          const SizedBox(height: 14),

          // Buttons: Cancel (left) + Exit (right)
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(result: false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(
                    cancelLabel,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E5E59), // app teal-ish color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.16),
                  ),
                  child: Text(
                    exitLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}