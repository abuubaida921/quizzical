import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

class OptionTileWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget trailing;

  const OptionTileWidget({
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