import 'package:flutter/material.dart';
import 'package:haliz_app/constants/colors.dart';
import '../models/product.dart';
import 'package:haliz_app/utils/price_comparison_utils.dart';
import 'package:haliz_app/widgets/price_change_indicator.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Product? previousProduct;

  const ProductCard({
    super.key,
    required this.product,
    this.previousProduct,
  });

  @override
  Widget build(BuildContext context) {
    final priceChange = PriceComparisonUtils.calculatePriceChangePercentage(
      product,
      previousProduct,
    );

    final absolutePriceChange = previousProduct != null
        ? product.averagePrice - previousProduct!.averagePrice
        : null;

    return Card(
      color: AppColors.lightGreen,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://eislem.izmir.bel.tr/YuklenenDosyalar/HalGorselleri/${product.imageUrl}',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 48),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (previousProduct != null && priceChange != 0)
                        PriceChangeIndicator(
                          percentage: priceChange,
                          priceChange: absolutePriceChange,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${product.unit} - ${product.type}'),
                  Text(
                    'Ortalama: ${product.averagePrice.toStringAsFixed(2)} ₺',
                  ),
                  Text('Min: ${product.minPrice}₺ / Max: ${product.maxPrice}₺'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
