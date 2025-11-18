import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/assets.dart';
import '../controllers/category_controller.dart';
import '../../data/models/category_model.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryController c = Get.find<CategoryController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Category'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (c.error.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Failed to load categories', ),
                  const SizedBox(height: 8),
                  Text(c.error.value ?? '', textAlign: TextAlign.center),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: c.loadCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final list = c.categories;
        if (list.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        // Responsive grid: 2 columns on narrow, 3 on wide screens
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : (MediaQuery.of(context).size.width > 600 ? 3 : 2),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final cat = list[index];
              return _CategoryCard(category: cat, onTap: () => c.selectCategory(cat));
            },
          ),
        );
      }),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const _CategoryCard({Key? key, required this.category, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // color palette per card (nice variance)
    const palette = [
      Color(0xFFEEF7F6),
      Color(0xFFFFF4EC),
      Color(0xFFF6F7FF),
      Color(0xFFF8F5FF),
      Color(0xFFEFFAF0),
    ];
    final bg = palette[category.id % palette.length];

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top-left small icon (optional)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  // try to use an icon from assets if available
                  child: Image.asset(
                    Assets.assetImages.question,
                    width: 22,
                    height: 22,
                    errorBuilder: (context, e, st) => Icon(Icons.category, color: Colors.grey[700], size: 20),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to select',
              ),
            ],
          ),
        ),
      ),
    );
  }
}