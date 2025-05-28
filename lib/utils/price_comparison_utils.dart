import 'package:haliz_app/models/product.dart';

class PriceComparisonUtils {
  static double calculatePriceChangePercentage(Product currentProduct, Product? previousProduct) {
    if (previousProduct == null) return 0.0;
    
    final currentPrice = currentProduct.averagePrice;
    final previousPrice = previousProduct.averagePrice;
    
    if (previousPrice == 0) return 0.0;
    
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }

  static String formatPriceChange(double percentage) {
    if (percentage == 0) return '0%';
    
    final sign = percentage > 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(1)}%';
  }

  static bool isPriceIncreased(double percentage) {
    return percentage > 0;
  }

  static bool isPriceDecreased(double percentage) {
    return percentage < 0;
  }
} 