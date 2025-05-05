// lib/features/stock/category/category_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _service = CategoryService();
  List<dynamic> categories = [];
  Map<String, dynamic> meta = {};
  bool isLoading = false;

  int currentPage = 1;
  int limit = 10;
  String? search;

  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await _service.getAllCategories(
        search: search,
        limit: limit,
        page: currentPage,
      );
      categories = result['data'];
      meta = result['meta'];
    } catch (e) {
      debugPrint('❌ Error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(BuildContext context, String id) async {
    try {
      await _service.deleteCategory(id);
      fetchCategories();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void updateSearch(String value) {
    search = value;
    currentPage = 1;
    fetchCategories();
  }

  void nextPage() {
    if ((meta['page'] ?? 1) < (meta['totalPages'] ?? 1)) {
      currentPage++;
      fetchCategories();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchCategories();
    }
  }
}
