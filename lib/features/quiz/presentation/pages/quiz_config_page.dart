import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_colors.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import 'package:quizzical/core/utils/loader_util.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/assets.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/dropdown_item_widget.dart';

class QuizConfigPage extends StatefulWidget {
  const QuizConfigPage({super.key});

  @override
  State<QuizConfigPage> createState() => _QuizConfigPageState();
}

class _QuizConfigPageState extends State<QuizConfigPage> {
  final QuizController controller = Get.find<QuizController>();

  // Local reactive states
  final RxInt numQuestions = 25.obs;
  final RxString difficulty = 'any'.obs;
  final RxString type = 'any'.obs;

  late int categoryId;
  late String categoryName;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    categoryId = args?['categoryId'] ?? 0;
    categoryName = args?['categoryName'] ?? "Category";
  }

  Future<void> _startQuiz() async {
    if (controller.isLoading.value) return;

    // Show blocking loader
    Get.dialog(
      LoaderUtil.showBeautifulLoader(Colors.white),
      barrierDismissible: false,
    );

    try {
      await controller.loadQuizList(amount: numQuestions.value, categoryId: categoryId,difficulty: difficulty.value,type: type.value);
      if (Get.isDialogOpen == true) Get.back();
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Top Image
            Center(
              child: Image.asset(
                Assets.assetImages.splashLogo,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 2),
                      child: Text(AppConstants.appName, style: AppTextStyles.heading1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 2),
                      child: Text(
                        AppConstants.configPageSubtitle,
                        style: AppTextStyles.heading1SubTitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number of Questions
                    Text('Number of Questions', style: AppTextStyles.catTitle),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select 1–50", style: AppTextStyles.bodySmall),
                        Obx(() => Text(
                          "${numQuestions.value}",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF1E9AE6),
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),

                    Obx(
                          () => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFF1E9AE6),
                          inactiveTrackColor: Colors.grey.shade300,
                          trackHeight: 6,
                          thumbColor: const Color(0xFF1E9AE6),
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

                    const SizedBox(height: 20),

                    // Difficulty
                    Text('Difficulty Level', style: AppTextStyles.catTitle),
                    const SizedBox(height: 6),

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
                              dropDownItemWidget("any", "Any Difficulty"),
                              dropDownItemWidget("easy", "Easy"),
                              dropDownItemWidget("medium", "Medium"),
                              dropDownItemWidget("hard", "Hard"),
                            ],
                            onChanged: (v) => difficulty.value = v ?? 'any',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Type
                    Text('Question Type', style: AppTextStyles.catTitle),
                    const SizedBox(height: 6),

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
                              dropDownItemWidget("any", "Any Type"),
                              dropDownItemWidget("multiple", "Multiple Choice"),
                              dropDownItemWidget("boolean", "True / False"),
                            ],
                            onChanged: (v) => type.value = v ?? 'any',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 26),
                  ],
                ),
              ),
            ),

            // START Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() {
                return OutlinedButton(
                  onPressed: controller.isLoading.value ? null : _startQuiz,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: controller.isLoading.value
                          ? Colors.grey.shade400
                          : AppColors.nextBtnBgColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'START',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: controller.isLoading.value
                          ? Colors.grey.shade400
                          : AppColors.nextBtnBgColor,
                      fontSize: 22,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Category: $categoryName",
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
