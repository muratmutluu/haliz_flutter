import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:haliz_app/enums/category_type.dart';
import 'package:haliz_app/models/product.dart';
import 'package:haliz_app/utils/date_utils.dart';

class ProductService {
  static const String _baseUrl =
      "https://openapi.izmir.bel.tr/api/ibb/halfiyatlari";

  Future<List<Product>> fetchProducts(
    String date,
    CategoryType category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/${category.apiPath}/$date"),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> productsJson = data['HalFiyatListesi'];

        if (productsJson.isEmpty) {
          throw Exception('Veri bulunamadı');
        }

        return productsJson.map((json) => Product.fromJson(json)).toList();
      } else if (response.statusCode == 204) {
        throw Exception('Bu tarihte veri bulunamadı');
      } else {
        throw Exception('API Hatası: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('İnternet bağlantısı yok');
      }
      throw Exception('Veri alınırken hata oluştu: $e');
    }
  }

  Future<Map<String, List<Product>>> fetchProductsWithComparison(
    String date,
    CategoryType category, {
    String? comparisonDate,
  }) async {
    try {
      // Bugünün verilerini çek
      final currentDate = date;
      final currentResponse = await http.get(
        Uri.parse("$_baseUrl/${category.apiPath}/$currentDate"),
      );

      if (currentResponse.statusCode != 200) {
        throw Exception('API Hatası: ${currentResponse.statusCode}');
      }

      final currentData = json.decode(currentResponse.body);
      final List<dynamic> currentProductsJson = currentData['HalFiyatListesi'];

      if (currentProductsJson.isEmpty) {
        throw Exception('Veri bulunamadı');
      }

      final currentProducts =
          currentProductsJson.map((json) => Product.fromJson(json)).toList();

      // Karşılaştırma verilerini çek
      List<Product> previousProducts = [];

      // Eğer karşılaştırma tarihi belirtilmişse onu kullan, yoksa önceki günü kullan
      final compareDate =
          comparisonDate ??
          DateUtilsHelper.getPreviousDate(DateTime.parse(date));

      final previousResponse = await http.get(
        Uri.parse("$_baseUrl/${category.apiPath}/$compareDate"),
      );

      if (previousResponse.statusCode == 200) {
        final previousData = json.decode(previousResponse.body);
        final List<dynamic> previousProductsJson =
            previousData['HalFiyatListesi'] ?? [];
        previousProducts =
            previousProductsJson.map((json) => Product.fromJson(json)).toList();
      }

      return {'current': currentProducts, 'previous': previousProducts};
    } catch (e) {
      if (e is SocketException) {
        throw Exception('İnternet bağlantısı yok');
      }
      throw Exception('Veri alınırken hata oluştu: $e');
    }
  }
}
