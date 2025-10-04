import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';
import '../../../data/services/brand_service.dart';
import '../../../data/services/product_type_service.dart';

class TransactionController extends ChangeNotifier {
  final productService = ProductService();
  final brandService = BrandService();
  final productTypeService = ProductTypeService();

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> brands = [];
  List<Map<String, dynamic>> productTypes = [];
  List<Map<String, dynamic>> cart = [];

  int currentPage = 1;
  int totalPage = 1;
  bool isLoading = false;
  String? search;

  String? selectedBrandId;
  String? selectedProductTypeId;

  Future<void> initData() async {
    await Future.wait([
      fetchBrands(),
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

  Future<void> fetchProductTypes() async {
    final res = await productTypeService.getAllProductTypes();
    productTypes = List<Map<String, dynamic>>.from(res);
  }

  void setSearch(String? value) {
    search = value;
    currentPage = 1;
    fetchProducts();
  }

  void setFilter({String? brandId, String? typeId}) {
    if (brandId != null || brandId == null) selectedBrandId = brandId;
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

  // [FUNGSI BARU]: Menambah kuantitas item di keranjang
  void incrementCartItemQuantity(int index) {
    if (index >= 0 && index < cart.length) {
      cart[index]['quantity']++;
      notifyListeners();
    }
  }

  // [FUNGSI BARU]: Mengurangi kuantitas item di keranjang
  void decrementCartItemQuantity(int index) {
    if (index >= 0 && index < cart.length) {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        // Jika kuantitas 1 dan dikurangi lagi, hapus item dari keranjang
        removeFromCart(index);
      }
      notifyListeners();
    }
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