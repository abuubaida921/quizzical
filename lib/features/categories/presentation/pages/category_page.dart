import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_text_style.dart';
import '../../../../core/constants/app_constants.dart';
import '../controllers/category_controller.dart';
import '../widgets/category_card_widget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();

}

class _CategoryPageState extends State<CategoryPage> {

  final CategoryController controller = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    controller.getFeaturedDealList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6, left: 2),
              child: Text(AppConstants.appName, style: AppTextStyles.heading1),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 2),
              child: Text(
                AppConstants.appNameSubTitle,
                style: AppTextStyles.heading1SubTitle,
              ),
            ),

            // LISTEN USING Obx
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = controller.categoryList ?? [];

                if (categories.isEmpty) {
                  return Center(
                    child: Text(
                      'No categories available',
                      style: AppTextStyles.bodySmall
                    ),
                  );
                }

                // Responsive grid
                final width = MediaQuery.of(context).size.width;
                final crossAxis = width > 900 ? 4 : (width > 600 ? 3 : 2);

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 4 / 5,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return CategoryCardWidget(
                      category: cat,
                      index: index,
                      onTap: () => controller.selectCategory(cat),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
