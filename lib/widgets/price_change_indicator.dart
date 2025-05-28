import 'package:flutter/material.dart';
import 'package:haliz_app/constants/colors.dart';

class PriceChangeIndicator extends StatelessWidget {
  final double percentage;
  final double? priceChange;

  const PriceChangeIndicator({
    super.key,
    required this.percentage,
    this.priceChange,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = percentage > 0;
    final color = isPositive ? AppColors.negativeChange : AppColors.positiveChange;
    final sign = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            priceChange != null 
                ? '$sign${priceChange!.toStringAsFixed(1)}TL | $sign${percentage.toStringAsFixed(1)}%'
                : '$sign${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 