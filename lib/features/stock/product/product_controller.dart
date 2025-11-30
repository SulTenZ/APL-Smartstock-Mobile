// lib/features/stock/product/product_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  
  List<dynamic> products = [];
  Map<String, dynamic>? pagination;
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10;
  
  bool get hasMore {
    if (pagination == null) return false;
    return (pagination!['currentPage'] ?? 1) < (pagination!['totalPages'] ?? 1);
  }
  
  // Get all products
  Future<void> getProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      products = [];
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    
    try {
      errorMessage = null;
      notifyListeners();
      
      final result = await _productService.getAllProducts(
        search: searchQuery.isNotEmpty ? searchQuery : null,
        page: currentPage,
        limit: itemsPerPage,
      );
      
      if (refresh || currentPage == 1) {
        products = result['data'];
      } else {
        products.addAll(result['data']);
      }
      
      pagination = result['pagination'];
      
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }
  
  // Load next page of products
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    
    currentPage++;
    await getProducts();
  }
  
  // Search products
  Future<void> searchProducts(String query) async {
    searchQuery = query;
    await getProducts(refresh: true);
  }
  
  // Get low stock products
  Future<List<dynamic>> getLowStockProducts() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      
      final result = await _productService.getLowStockProducts();
      
      isLoading = false;
      notifyListeners();
      
      return result;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }
  
  // Delete product
  Future<bool> deleteProduct(String id) async {
    try {
      await _productService.deleteProduct(id);
      
      // Remove the product from the list
      products.removeWhere((product) => product['id'] == id);
      
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Sync all product stocks
  Future<bool> syncAllStocks() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      
      await _productService.syncAllProductStocks();
      
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}