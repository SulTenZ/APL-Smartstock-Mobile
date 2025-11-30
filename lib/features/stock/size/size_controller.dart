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
  bool isLoadingMore = false;
  int currentPage = 1;
  int limit = 10;
  String? search;
  String? selectedProductTypeId;

  bool get hasMore {
    final totalPages = meta['totalPages'] ?? 1;
    return currentPage < totalPages;
  }

  Future<void> fetchSizes({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isLoadingMore = true;
    } else {
      isLoading = true;
      currentPage = 1;
      sizes.clear();
    }
    notifyListeners();

    try {
      final result = await _sizeService.getAllSizes(
        search: search,
        limit: limit,
        page: currentPage,
        productTypeId: selectedProductTypeId,
      );
      
      if (isLoadMore) {
        sizes.addAll(List<Map<String, dynamic>>.from(result['data']));
      } else {
        sizes = List<Map<String, dynamic>>.from(result['data']);
      }
      
      meta = result['meta'];
    } catch (e) {
      debugPrint('Error fetchSizes: $e');
    }

    if (isLoadMore) {
      isLoadingMore = false;
    } else {
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    
    currentPage++;
    await fetchSizes(isLoadMore: true);
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
      await fetchSizes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void updateSearch(String value) {
    search = value;
    fetchSizes();
  }

  void nextPage() {
    if (hasMore) {
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

  void setProductTypeFilter(String? productTypeId) {
    selectedProductTypeId = productTypeId;
    fetchSizes();
  }

  void clearFilters() {
    search = null;
    selectedProductTypeId = null;
    fetchSizes();
  }
}