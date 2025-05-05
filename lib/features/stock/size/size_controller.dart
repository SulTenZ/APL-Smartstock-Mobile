// lib/features/stock/size/size_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/size_service.dart';
import '../../../data/services/product_type_service.dart';

class SizeController extends ChangeNotifier {
  final SizeService _sizeService = SizeService();
  final ProductTypeService _productTypeService = ProductTypeService();

  List<Map<String, dynamic>> sizes = [];
  List<Map<String, dynamic>> productTypes = [];
  Map<String, dynamic> meta = {};

  bool isLoading = false;
  int currentPage = 1;
  int limit = 10;
  String? search;
  String? selectedProductTypeId;

  Future<void> fetchSizes() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await _sizeService.getAllSizes(
        search: search,
        limit: limit,
        page: currentPage,
        productTypeId: selectedProductTypeId,
      );
      sizes = List<Map<String, dynamic>>.from(result['data']);
      meta = result['meta'];
    } catch (e) {
      debugPrint('Error fetchSizes: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductTypes() async {
    try {
      final data = await _productTypeService.getAllProductTypes();
      productTypes = List<Map<String, dynamic>>.from(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetchProductTypes: $e');
    }
  }

  Future<void> deleteSize(BuildContext context, String id) async {
    try {
      await _sizeService.deleteSize(id);
      fetchSizes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void updateSearch(String value) {
    search = value;
    currentPage = 1;
    fetchSizes();
  }

  void nextPage() {
    if ((meta['page'] ?? 1) < (meta['totalPages'] ?? 1)) {
      currentPage++;
      fetchSizes();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchSizes();
    }
  }
}
