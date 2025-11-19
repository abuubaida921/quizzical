import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzical/core/theme/app_text_style.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/category_model.dart';
import '../controllers/category_controller.dart';
import '../../../../core/constants/assets.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  static const _subtitle = 'choose a category to focus on:';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              child: Text(
                'Quizzical',
                style: AppTextStyles.heading1
              ),
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 2),
              child: Text(
                _subtitle,
                style: AppTextStyles.heading1SubTitle
              ),
            ),

            // Content (grid view)
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Failed to load categories', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(controller.error.value ?? '', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: controller.loadCategories, child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                final categories = controller.categories;
                if (categories.isEmpty) {
                  return Center(child: Text('No categories available', style: theme.textTheme.bodyMedium));
                }

                // Responsive grid: 2 columns on mobile, 3 on tablet/large
                final width = MediaQuery.of(context).size.width;
                final crossAxis = width > 900 ? 4 : (width > 600 ? 3 : 2);

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 20),
                  itemCount: categories.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return _CategoryCard(
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

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  String _assetForCategory(CategoryModel cat) {
    final key = cat.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    return 'assets/images/categories/$key.png';
  }

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.catBgPalette[index % AppColors.catBgPalette.length];

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Image.asset(
                      _assetForCategory(category),
                      fit: BoxFit.contain,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Image.asset(
                            Assets.assetImages.categoryIllustration,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Icon(Icons.image, size: 56, color: Colors.grey[400]),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.catTitle

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}