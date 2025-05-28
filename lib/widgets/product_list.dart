import 'package:flutter/material.dart';
import 'package:haliz_app/enums/category_type.dart';
import 'package:haliz_app/enums/product_type.dart';
import 'package:haliz_app/models/product.dart';
import 'package:haliz_app/widgets/product_card.dart';

class ProductList extends StatelessWidget {
  final Future<List<Product>> products;
  final List<Product> previousProducts;
  final ProductType selectedType;
  final CategoryType selectedCategory;
  final VoidCallback onRetry;

  const ProductList({
    super.key,
    required this.products,
    required this.previousProducts,
    required this.selectedType,
    required this.selectedCategory,
    required this.onRetry,
  });

  Product? _findPreviousProduct(Product currentProduct) {
    try {
      return previousProducts.firstWhere(
        (product) => product.name == currentProduct.name,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bir hata oluştu'),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final productList = snapshot.data!;
        return ListView.builder(
          itemCount: productList.length,
          itemBuilder: (context, index) {
            final product = productList[index];
            final previousProduct = _findPreviousProduct(product);

            return ProductCard(
              product: product,
              previousProduct: previousProduct,
            );
          },
        );
      },
    );
  }
}
