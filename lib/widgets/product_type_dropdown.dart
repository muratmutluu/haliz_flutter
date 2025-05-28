import 'package:flutter/material.dart';
import 'package:haliz_app/enums/product_type.dart';

class ProductTypeDropdown extends StatelessWidget {
  final ProductType selectedType;
  final Function(ProductType) onChanged;

  const ProductTypeDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = ProductType.values;

    return DropdownButton<ProductType>(
      value: selectedType,
      isExpanded: true,
      items:
          types.map((type) {
            return DropdownMenuItem<ProductType>(
              value: type,
              child: Row(
                children: [
                  Image.asset(type.iconPath, width: 24, height: 24),
                  const SizedBox(width: 8),
                  Text(type.name),
                ],
              ),
            );
          }).toList(),
      onChanged: (newValue) => onChanged(newValue!),
    );
  }
}
