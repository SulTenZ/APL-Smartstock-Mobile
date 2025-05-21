// lib/features/transaction/transaction_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';
import '../../../data/services/brand_service.dart';
import '../../../data/services/category_service.dart';
import '../../../data/services/product_type_service.dart';

class TransactionController extends ChangeNotifier {
  final productService = ProductService();
  final brandService = BrandService();
  final categoryService = CategoryService();
  final productTypeService = ProductTypeService();

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> brands = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> productTypes = [];
  List<Map<String, dynamic>> cart = [];

  int currentPage = 1;
  int totalPage = 1;
  bool isLoading = false;
  String? search;

  String? selectedBrandId;
  int? selectedCategoryId;
  String? selectedProductTypeId;

  Future<void> initData() async {
    await Future.wait([
      fetchBrands(),
      fetchCategories(),
      fetchProductTypes(),
      fetchProducts(),
    ]);
  }

  Future<void> fetchProducts() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await productService.getAllProducts(
        page: currentPage,
        search: search,
        brandId: selectedBrandId,
        categoryId: selectedCategoryId,
        productTypeId: selectedProductTypeId,
      );
      products = List<Map<String, dynamic>>.from(result['data']);
      totalPage = result['pagination']['totalPages'] ?? 1;
    } catch (e) {
      print('❌ Error fetchProducts: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBrands() async {
    final res = await brandService.getAllBrands();
    brands = List<Map<String, dynamic>>.from(res['data']);
  }

  Future<void> fetchCategories() async {
    final res = await categoryService.getAllCategories();
    categories = List<Map<String, dynamic>>.from(res['data']);
  }

  Future<void> fetchProductTypes() async {
    final res = await productTypeService.getAllProductTypes();
    productTypes = List<Map<String, dynamic>>.from(res);
  }

  void setSearch(String? value) {
    search = value;
    currentPage = 1;
    fetchProducts();
  }

  void setFilter({String? brandId, int? categoryId, String? typeId}) {
    if (brandId != null || brandId == null) selectedBrandId = brandId;
    if (categoryId != null) selectedCategoryId = categoryId;
    if (typeId != null) selectedProductTypeId = typeId;
    currentPage = 1;
    fetchProducts();
  }

  void addToCart(Map<String, dynamic> product) {
    cart.add(product);
    notifyListeners();
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  double get totalHarga =>
      cart.fold(0, (sum, item) => sum + (item['hargaJual'] * item['quantity']));

  void goToNextPage() {
    if (currentPage < totalPage) {
      currentPage++;
      fetchProducts();
    }
  }

  void goToPrevPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchProducts();
    }
  }
}
