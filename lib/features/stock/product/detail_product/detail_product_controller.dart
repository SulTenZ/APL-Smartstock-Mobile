// lib/features/stock/product/detail_product/detail_product_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/product_service.dart';
import '../../../../data/services/stock_batch_service.dart';

class DetailProductController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final StockBatchService _stockBatchService = StockBatchService();

  Map<String, dynamic>? product;
  Map<String, dynamic>? stockBatch;
  bool isLoading = false;
  bool isLoadingBatch = false;
  String? errorMessage;
  String? batchErrorMessage;

  // Get product details by ID
  Future<void> getProductDetails(String productId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      product = await _productService.getProductById(productId);

      // Fetch stock batch if product has stockBatchId
      if (product != null && product!['stockBatchId'] != null) {
        await getStockBatchDetails(product!['stockBatchId']);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      product = null;
      notifyListeners();
    }
  }

  // Get stock batch details by ID
  Future<void> getStockBatchDetails(String stockBatchId) async {
    try {
      isLoadingBatch = true;
      batchErrorMessage = null;
      notifyListeners();

      stockBatch = await _stockBatchService.getStockBatchById(stockBatchId);

      isLoadingBatch = false;
      notifyListeners();
    } catch (e) {
      isLoadingBatch = false;
      batchErrorMessage = e.toString();
      stockBatch = null;
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
    // --- MULAI DEBUGGING LOG ---
    print("🚀 [DEBUG] Memulai updateProductSize...");
    print("   - productSizeId: $productSizeId");
    print("   - quantity: $quantity");
    // --- AKHIR DEBUGGING LOG ---

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Panggilan service ini sudah benar, akan menargetkan:
      // PUT /api/product-sizes/{productSizeId}
      await _productService.updateProductSize(
        productSizeId: productSizeId,
        quantity: quantity,
      );

      // Refresh product details after updating size
      if (product != null && product!['id'] != null) {
        await getProductDetails(product!['id']);
      }

      isLoading = false;
      notifyListeners();
      
      // --- MULAI DEBUGGING LOG ---
      print("✅ [DEBUG] updateProductSize BERHASIL.");
      // --- AKHIR DEBUGGING LOG ---
      
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      
      // --- MULAI DEBUGGING LOG ---
      print("❌ [DEBUG] updateProductSize GAGAL. Error: $errorMessage");
      // --- AKHIR DEBUGGING LOG ---

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

  // Get stock batch summary
  Map<String, dynamic>? getStockBatchSummary() {
    if (stockBatch == null) return null;
    return _stockBatchService.getBatchSummary(stockBatch!);
  }

  // Calculate average cost per item from batch
  double getAverageCostPerItem() {
    if (stockBatch == null) return 0.0;
    return _stockBatchService.calculateAverageCostPerItem(stockBatch!);
  }

  // Check if product is part of a batch
  bool hasStockBatch() {
    return product != null && 
           product!['stockBatchId'] != null && 
           stockBatch != null;
  }

  // Get batch name
  String? getBatchName() {
    return stockBatch?['nama'];
  }

  // Get batch total price
  double getBatchTotalPrice() {
    return stockBatch?['totalHarga']?.toDouble() ?? 0.0;
  }

  // Get batch total shoes count
  int getBatchTotalShoes() {
    return stockBatch?['jumlahSepatu']?.toInt() ?? 0;
  }

  // Refresh both product and batch data
  Future<void> refreshData() async {
    if (product != null && product!['id'] != null) {
      await getProductDetails(product!['id']);
    }
  }
}