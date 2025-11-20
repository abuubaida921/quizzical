import 'package:flutter/material.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import '../../../../core/constants/assets.dart';

Widget buildIllustration(BuildContext context) {
  return LayoutBuilder(builder: (context, constraints) {
    return Image.asset(
      Assets.assetImages.welcomeIllustration,
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
                      color: AppColors.secondary
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