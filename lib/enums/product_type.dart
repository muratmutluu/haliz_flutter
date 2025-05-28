enum ProductType { tumu, sebze, meyve, ithal }

extension ProductTypeExtension on ProductType {
  String get name {
    switch (this) {
      case ProductType.tumu:
        return 'Tümü';
      case ProductType.sebze:
        return 'Sebze';
      case ProductType.meyve:
        return 'Meyve';
      case ProductType.ithal:
        return 'İthal';
    }
  }

  String get iconPath {
    switch (this) {
      case ProductType.tumu:
        return 'assets/icons/shopping_cart.png'; // Genel bir ikon
      case ProductType.sebze:
        return 'assets/icons/carrot.png'; // Sebze ikonu
      case ProductType.meyve:
        return 'assets/icons/green_apple.png'; // Meyve ikonu
      case ProductType.ithal:
        return 'assets/icons/earth.png'; // İthal ikonu
    }
  }
}
