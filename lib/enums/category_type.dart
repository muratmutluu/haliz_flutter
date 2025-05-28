enum CategoryType { sebzeMeyve, balik }

extension CategoryTypeExtension on CategoryType {
  String get name {
    switch (this) {
      case CategoryType.sebzeMeyve:
        return 'Sebze ve Meyve';
      case CategoryType.balik:
        return 'Balık';
    }
  }

  String get apiPath {
    switch (this) {
      case CategoryType.sebzeMeyve:
        return 'sebzemeyve';
      case CategoryType.balik:
        return 'balik';
    }
  }

  String get iconPath {
    switch (this) {
      case CategoryType.sebzeMeyve:
        return 'assets/icons/tomato.png'; // Sebze ve Meyve ikonu
      case CategoryType.balik:
        return 'assets/icons/fish.png'; // Balık ikonu
    }
  }
}
