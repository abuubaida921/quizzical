import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const _primaryButtonColor = Color(0xFF0F7B71);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 50),
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
                style: GoogleFonts.aoboshiOne(
                  fontSize: 48,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed(AppPages.categories);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.18),
                    ),
                    child: Text(
                      'GET STARTED',
                      style: GoogleFonts.baloo2(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
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