import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../domain/models/category_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback onTap;

  const CategoryCardWidget({super.key,
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
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
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
                            errorBuilder: (c, e, s) => Icon(
                              Icons.image,
                              size: 56,
                              color: Colors.grey[400],
                            ),
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
                  style: AppTextStyles.catTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}