import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/utils/toast_util.dart';
import '../controllers/quiz_controller.dart';
import '../../../../routes/app_pages.dart';

class QuizConfigPage extends GetView<QuizController> {
  const QuizConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive local UI state keeps the page stateless
    final RxInt numQuestions = 25.obs;
    final RxString difficulty = 'any'.obs;
    final RxString type = 'any'.obs;
    final RxBool isLoading = false.obs;

    // Read arguments (categoryId / categoryName) from previous page
    final args = Get.arguments;
    final int categoryId = (args is Map && args['categoryId'] != null) ? (args['categoryId'] as int) : 0;
    final String categoryName = (args is Map && args['categoryName'] != null) ? (args['categoryName'] as String) : 'Category';

    Future<void> _startQuiz() async {
      if (isLoading.value) return;

      isLoading.value = true;

      // Show a modal loading indicator using Get.dialog (no BuildContext issues)
      Get.dialog<void>(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        await controller.loadQuiz(
          amount: numQuestions.value,
          categoryId: categoryId,
          difficulty: difficulty.value,
          type: type.value,
        );

        // Dismiss loading modal and navigate to play page
        if (Get.isDialogOpen == true) Get.back();
        Get.offNamed(AppPages.quizPlayPage);
      } catch (e, st) {
        // Close loading dialog if still open
        if (Get.isDialogOpen == true) Get.back();

        // Prefer controller.error (set by controller) for friendly messages
        final err = controller.error.value;
        String title = 'Error';
        String message = 'Failed to load questions. Please try again.';

        if (err != null && err.isNotEmpty) {
          message = err;
        } else {
          final errText = e.toString().toLowerCase();
          if (errText.contains('triviaapiexception') || errText.contains('response_code')) {
            // try to parse the code out for a clearer message
            final m = RegExp(r'code[:\s]+(\d+)').firstMatch(errText);
            final code = m != null ? int.tryParse(m.group(1) ?? '') ?? -1 : -1;
            switch (code) {
              case 1:
                title = 'No Questions';
                message =
                'No questions are available for the selected filters. Try lowering the number of questions or selecting a different difficulty/type.';
                break;
              case 2:
                title = 'Invalid Request';
                message = 'One or more selected options are invalid. Please review your choices.';
                break;
              case 3:
              case 4:
                title = 'Session Error';
                message = 'A session error occurred with the trivia service. Please try again later.';
                break;
              default:
                title = 'Trivia Service';
                message = 'Trivia service returned an error. Please try again.';
            }
          } else if (errText.contains('no questions') || errText.contains('empty response')) {
            title = 'No Questions';
            message = 'No questions are available for that selection.';
          } else if (errText.contains('formatexception') || errText.contains('unexpected')) {
            title = 'Data Error';
            message = 'Received unexpected data from the server. Try again later.';
          } else {
            // generic fallback
            message = 'Failed to load questions. Try again.';
          }
        }

        // Show as toast (info for "no questions", error otherwise)
        final isNoQuestions = title.toLowerCase().contains('no question');
        try {
          if (isNoQuestions) {
            ToastUtil.info(context, message, title: title);
          } else {
            ToastUtil.error(context, message, title: title);
          }
        } catch (_) {
          // fallback to snack if ToastUtil fails
          if (kDebugMode) {
            // ignore: avoid_print
            print('ToastUtil failed, falling back to snackbar.');
          }
          Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
        }

        if (kDebugMode) {
          // helpful debug log
          // ignore: avoid_print
          print('QuizConfigPage _startQuiz error: $e\n$st');
        }
      } finally {
        isLoading.value = false;
      }
    }

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
                  width: 350,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Icon(Icons.settings_rounded, size: 96, color: Colors.grey[300]),
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Title + subtitle
            Text(
              'Quizzical',
              style: AppTextStyles.appTitle,
            ),
            const SizedBox(height: 6),
            Text(
              'Configuration',
              style: AppTextStyles.heading1SubTitle.copyWith(color: AppColors.categoryTitlePrimary)
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
                      style: AppTextStyles.catTitle,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Select 1–50',
                                    style: AppTextStyles.bodySmall
                                  ),

                                  // numeric value on right
                                  Obx(
                                        () => Text(
                                      '${numQuestions.value}',
                                      style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF1E9AE6),fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                    () => SliderTheme(
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
                                    value: numQuestions.value.toDouble(),
                                    onChanged: (v) => numQuestions.value = v.round(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Difficulty Label
                    Text(
                      'Difficulty Level',
                      style: AppTextStyles.catTitle,
                    ),
                    const SizedBox(height: 8),

                    // Difficulty dropdown
                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: difficulty.value,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(value: 'any', child: Text('Any Difficulty',style: AppTextStyles.bodySmall,)),
                              DropdownMenuItem(value: 'easy', child: Text('Easy',style: AppTextStyles.bodySmall,)),
                              DropdownMenuItem(value: 'medium', child: Text('Medium',style: AppTextStyles.bodySmall,)),
                              DropdownMenuItem(value: 'hard', child: Text('Hard',style: AppTextStyles.bodySmall,)),
                            ],
                            onChanged: (val) => difficulty.value = val ?? 'any',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Question Type
                    Text(
                      'Question Type',
                      style: AppTextStyles.catTitle,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: type.value,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(value: 'any', child: Text('Any Type',style: AppTextStyles.bodySmall,)),
                              DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice',style: AppTextStyles.bodySmall,)),
                              DropdownMenuItem(value: 'boolean', child: Text('True / False',style: AppTextStyles.bodySmall,)),
                            ],
                            onChanged: (val) => type.value = val ?? 'any',
                          ),
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
                height: 50,
                child: Obx(
                      () => OutlinedButton(
                    onPressed: isLoading.value ? null : _startQuiz,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isLoading.value ? Colors.grey.shade400 : const Color(0xFF0E5E59),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'START',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: isLoading.value ? Colors.grey.shade400 : const Color(0xFF0E5E59),fontSize: 22
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // small footer hint showing selected category
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Category: $categoryName',
                style: AppTextStyles.bodySmall
              ),
            ),
          ],
        ),
      ),
    );
  }
}