import 'package:flutter/material.dart';

enum SortType {
  nameAsc('A-Z'),
  nameDesc('Z-A'),
  priceAsc('Fiyat'),
  priceDesc('Fiyat');

  final String label;
  const SortType(this.label);

  IconData get icon {
    switch (this) {
      case SortType.nameAsc:
        return Icons.sort_by_alpha;
      case SortType.nameDesc:
        return Icons.sort_by_alpha_outlined;
      case SortType.priceAsc:
        return Icons.arrow_upward;
      case SortType.priceDesc:
        return Icons.arrow_downward;
    }
  }
} 