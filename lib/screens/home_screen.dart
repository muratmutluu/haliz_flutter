import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haliz_app/constants/colors.dart';
import 'package:haliz_app/enums/category_type.dart';
import 'package:haliz_app/enums/product_type.dart';
import 'package:haliz_app/enums/sort_type.dart';
import 'package:haliz_app/utils/date_utils.dart';
import 'package:haliz_app/utils/network_utils.dart';
import 'package:haliz_app/widgets/category_dropdown.dart';
import 'package:haliz_app/widgets/no_data_view.dart';
import 'package:haliz_app/widgets/no_internet_page.dart';
import 'package:haliz_app/widgets/product_list.dart';
import 'package:haliz_app/widgets/product_type_dropdown.dart';
import 'package:haliz_app/widgets/selected_date_info.dart';
import 'package:intl/intl.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? comparisonDate; // Karşılaştırma için ikinci tarih
  ProductType selectedType = ProductType.tumu;
  CategoryType selectedCategory = CategoryType.sebzeMeyve;
  SortType selectedSort = SortType.nameAsc;
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    selectedDate = DateUtilsHelper.getValidDate(DateTime.now());
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final hasInternet = await NetworkUtils.checkInternetConnection();
    if (!hasInternet) {
      return {'hasInternet': false, 'products': null};
    }

    try {
      final productsData = await _productService.fetchProductsWithComparison(
        selectedDate,
        selectedCategory,
        comparisonDate: comparisonDate, // Karşılaştırma tarihini ekledik
      );
      return {
        'hasInternet': true,
        'currentProducts': productsData['current'],
        'previousProducts': productsData['previous'],
      };
    } catch (e) {
      return {'hasInternet': true, 'error': e.toString()};
    }
  }

  void _initializeData() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate),
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final validDate = DateUtilsHelper.getValidDate(picked);
      setState(() {
        selectedDate = validDate;
        _initializeData();
      });
    }
  }

  Future<void> _selectComparisonDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: comparisonDate != null 
          ? DateTime.parse(comparisonDate!) 
          : DateTime.parse(selectedDate),
      firstDate: DateTime(2020, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final validDate = DateUtilsHelper.getValidDate(picked);
      setState(() {
        comparisonDate = validDate;
        _initializeData();
      });
    }
  }

  void _handleCategoryChange(CategoryType newCategory) {
    setState(() {
      selectedCategory = newCategory;
      selectedType = ProductType.tumu;
      _initializeData();
    });
  }

  void _handleTypeChange(ProductType newType) {
    setState(() {
      selectedType = newType;
    });
  }

  void _handleSortChange(SortType? newSort) {
    if (newSort != null) {
      setState(() {
        selectedSort = newSort;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Product> _filterAndSortProducts(List<Product> products) {
    var filteredProducts = products;

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filteredProducts =
          products
              .where(
                (product) => product.name.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }

    // Sıralama
    switch (selectedSort) {
      case SortType.nameAsc:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.nameDesc:
        filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortType.priceAsc:
        filteredProducts.sort(
          (a, b) => a.averagePrice.compareTo(b.averagePrice),
        );
        break;
      case SortType.priceDesc:
        filteredProducts.sort(
          (a, b) => b.averagePrice.compareTo(a.averagePrice),
        );
        break;
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SvgPicture.asset('assets/title.svg', width: 112)],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CategoryDropdown(
                        selectedCategory: selectedCategory,
                        onChanged: _handleCategoryChange,
                      ),
                    ),
                  ],
                ),
                if (selectedCategory == CategoryType.sebzeMeyve)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ProductTypeDropdown(
                      selectedType: selectedType,
                      onChanged: _handleTypeChange,
                    ),
                  ),
                SelectedDateInfo(
                  selectedDate: selectedDate,
                  comparisonDate: comparisonDate,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: TextField(
                              controller: _searchController,
                              onChanged: _handleSearch,
                              decoration: InputDecoration(
                                hintText: 'Ürün Ara...',
                                prefixIcon: const Icon(Icons.search, size: 18),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: DropdownButtonFormField<SortType>(
                              value: selectedSort,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, size: 18),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                isDense: true,
                                alignLabelWithHint: true,
                              ),
                              items: SortType.values.map((sort) {
                                return DropdownMenuItem(
                                  value: sort,
                                  child: Row(
                                    children: [
                                      Icon(sort.icon, size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        sort.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: _handleSortChange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return NoInternetPage(onRetry: _initializeData);
                }

                final data = snapshot.data!;
                if (!data['hasInternet']) {
                  return NoInternetPage(onRetry: _initializeData);
                }

                if (data['error'] != null) {
                  return NoDataView(
                    message: 'Bu tarihte veri bulunamadı.\nLütfen başka bir tarih seçin.',
                    imagePath: 'assets/sad_carrot.png',
                    imageSize: 100,
                  );
                }

                final currentProducts = _filterAndSortProducts(
                  data['currentProducts'],
                );
                final previousProducts =
                    data['previousProducts'] as List<Product>? ?? [];

                if (currentProducts.isEmpty) {
                  return NoDataView(
                    message:
                        _searchQuery.isNotEmpty
                            ? 'Arama kriterlerinize uygun ürün bulunamadı.'
                            : 'Bu tarihte veri bulunamadı.',
                  );
                }

                return ProductList(
                  products: Future.value(currentProducts),
                  previousProducts: previousProducts,
                  selectedType: selectedType,
                  selectedCategory: selectedCategory,
                  onRetry: _initializeData,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text("Tarih Seç"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[50],
                        foregroundColor: Colors.green[800],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _selectComparisonDate(context),
                      icon: const Icon(Icons.compare_arrows, size: 18),
                      label: Text(
                        comparisonDate != null 
                            ? "Karşılaştırma Tarihini Değiştir"
                            : "Karşılaştırma Tarihi Seç",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: comparisonDate != null 
                            ? Colors.green[100] 
                            : Colors.green[50],
                        foregroundColor: Colors.green[800],
                      ),
                    ),
                  ),
                ],
              ),
              if (comparisonDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            comparisonDate = null;
                            _initializeData();
                          });
                        },
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text("Karşılaştırmayı Kaldır"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
