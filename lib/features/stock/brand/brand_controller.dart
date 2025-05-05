// lib/features/stock/brand/brand_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/brand_service.dart';

class BrandController extends ChangeNotifier {
  final BrandService _service = BrandService();

  List<dynamic> brands = [];
  Map<String, dynamic> meta = {};
  bool isLoading = false;

  int currentPage = 1;
  int limit = 10;
  String? search;

  Future<void> fetchBrands() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await _service.getAllBrands(
        search: search,
        limit: limit,
        page: currentPage,
      );
      brands = result['data'];
      meta = result['meta'];
    } catch (e) {
      debugPrint('❌ Error fetching brands: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBrand(BuildContext context, String id) async {
    try {
      await _service.deleteBrand(id);
      fetchBrands();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void updateSearch(String value) {
    search = value;
    currentPage = 1;
    fetchBrands();
  }

  void nextPage() {
    if ((meta['page'] ?? 1) < (meta['totalPages'] ?? 1)) {
      currentPage++;
      fetchBrands();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchBrands();
    }
  }
}