// lib/features/stock_history/stock_history_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/product_service.dart';

class StockHistoryController with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Map<String, dynamic>> stockHistory = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchStockHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _productService.getAllProducts();
      stockHistory = List<Map<String, dynamic>>.from(result['data']);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
