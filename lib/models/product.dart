class Product {
  final String name;
  final String unit;
  final String type;
  final double averagePrice;
  final double minPrice;
  final double maxPrice;
  final String imageUrl;

  Product({
    required this.name,
    required this.unit,
    required this.type,
    required this.averagePrice,
    required this.minPrice,
    required this.maxPrice,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['MalAdi'],
      unit: json['Birim'],
      type: json['MalTipAdi'],
      averagePrice: json['OrtalamaUcret'].toDouble(),
      minPrice: json['AsgariUcret'].toDouble(),
      maxPrice: json['AzamiUcret'].toDouble(),
      imageUrl: json['Gorsel'],
    );
  }
}
