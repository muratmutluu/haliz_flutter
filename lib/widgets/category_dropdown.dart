import 'package:flutter/material.dart';
import 'package:haliz_app/enums/category_type.dart';

class CategoryDropdown extends StatelessWidget {
  final CategoryType selectedCategory;
  final Function(CategoryType) onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryType>(
      value: selectedCategory,
      isExpanded: true,
      items:
          CategoryType.values.map((category) {
            return DropdownMenuItem<CategoryType>(
              value: category,
              child: Row(
                children: [
                  Image.asset(category.iconPath, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(category.name),
                ],
              ),
            );
          }).toList(),
      onChanged: (newCategory) => onChanged(newCategory!),
    );
  }
}
