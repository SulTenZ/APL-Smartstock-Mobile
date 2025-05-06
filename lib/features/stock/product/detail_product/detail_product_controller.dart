// lib/features/stock/product/detail_product/detail_product_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/product_service.dart';

class DetailProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();

  Map<String, dynamic>? product;
  bool isLoading = false;
  String? errorMessage;

  // Get product details by ID
  Future<void> getProductDetails(String productId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      product = await _productService.getProductById(productId);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      product = null;
      notifyListeners();
    }
  }

  // Add size to product
  Future<bool> addProductSize({
    required String productId,
    required String sizeId,
    required int quantity,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _productService.addProductSize(
        productId: productId,
        sizeId: sizeId,
        quantity: quantity,
      );

      // Refresh product details after adding size
      await getProductDetails(productId);

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

// Update product size (menggunakan productSizeId yang benar)
Future<bool> updateProductSize({
  required String productSizeId,
  required int quantity,
}) async {
  try {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    await _productService.updateProductSize(
      productSizeId: productSizeId,
      quantity: quantity,
    );

    // Refresh product details after updating size
    await getProductDetails(product?['id']);

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


  // Delete product size
  Future<bool> deleteProductSize({
    required String productId,
    required String sizeId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _productService.deleteProductSize(
        productId: productId,
        sizeId: sizeId,
      );

      // Refresh product details after deleting size
      await getProductDetails(productId);

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

  // Calculate total stock across all sizes
  int calculateTotalStock() {
    if (product == null || product!['sizes'] == null) return 0;

    final sizes = List<Map<String, dynamic>>.from(product!['sizes']);
    return sizes
        .fold<num>(0, (total, size) => total + (size['quantity'] ?? 0))
        .toInt();
  }

  // Check if stock is low
  bool isLowStock() {
    if (product == null) return false;

    final minStock = product!['minStock'] ?? 0;
    final totalStock = calculateTotalStock();

    return totalStock <= minStock;
  }
}
