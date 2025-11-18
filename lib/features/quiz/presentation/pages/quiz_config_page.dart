import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/routes/app_pages.dart';

import '../../../../core/constants/assets.dart';
import '../controllers/quiz_controller.dart';

class QuizConfigPage extends StatefulWidget {
  const QuizConfigPage({super.key});

  @override
  State<QuizConfigPage> createState() => _QuizConfigPageState();
}

class _QuizConfigPageState extends State<QuizConfigPage> {
  final QuizController _quizController = Get.find<QuizController>();

  // Local UI state
  int _numQuestions = 25;
  String _difficulty = 'any';
  String _type = 'any';

  late final int categoryId;
  late final String categoryName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    categoryId = (args is Map && args['categoryId'] != null) ? (args['categoryId'] as int) : 0;
    categoryName = (args is Map && args['categoryName'] != null) ? (args['categoryName'] as String) : 'Category';
  }

  Future<void> _onStartPressed() async {
    try {
      // show loading dialog while fetching
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await _quizController.loadQuiz(
        amount: _numQuestions,
        categoryId: categoryId,
        difficulty: _difficulty,
        type: _type,
      );

      // remove loading
      if (Get.isDialogOpen == true) Get.back();

      // navigate to play page
      Get.offNamed(AppPages.quizPlayPage);
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      Get.snackbar(
        'Error',
        'Failed to load questions. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 18),

            // Top illustration
            SizedBox(
              height: 160,
              child: Center(
                child: Image.asset(
                  Assets.assetImages.splashLogo,
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.settings_rounded, size: 96, color: Colors.grey[300]),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Title + subtitle
            Text(
              'Quizzical',
            ),
            const SizedBox(height: 6),
            Text(
              'Configuration',
            ),

            const SizedBox(height: 22),

            // Form area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number of Questions label
                    Text(
                      'Number of Questions',
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select 1–50',
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFF1E9AE6),
                                  inactiveTrackColor: Colors.grey.shade300,
                                  trackHeight: 6,
                                  thumbColor: const Color(0xFF1E9AE6),
                                  overlayColor: const Color(0xFF1E9AE6).withOpacity(0.12),
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                                ),
                                child: Slider(
                                  min: 1,
                                  max: 50,
                                  divisions: 49,
                                  value: _numQuestions.toDouble(),
                                  onChanged: (v) => setState(() => _numQuestions = v.round()),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // numeric value on right
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '$_numQuestions',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Difficulty Label
                    Text(
                      'Difficulty Level',
                    ),
                    const SizedBox(height: 8),

                    // Difficulty dropdown
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _difficulty,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'any', child: Text('Any Difficulty')),
                            DropdownMenuItem(value: 'easy', child: Text('Easy')),
                            DropdownMenuItem(value: 'medium', child: Text('Medium')),
                            DropdownMenuItem(value: 'hard', child: Text('Hard')),
                          ],
                          onChanged: (val) => setState(() {
                            _difficulty = val ?? 'any';
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Optional: Question Type (multiple / boolean) - kept compact and subtle
                    Text(
                      'Question Type',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _type,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'any', child: Text('Any Type')),
                            DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                            DropdownMenuItem(value: 'boolean', child: Text('True / False')),
                          ],
                          onChanged: (val) => setState(() => _type = val ?? 'any'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),

            // START button anchored to bottom (outlined, rounded with filled text color)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
              child: SizedBox(
                width: double.infinity,
                height: 68,
                child: OutlinedButton(
                  onPressed: _onStartPressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0E5E59), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'START',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF0E5E59),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}