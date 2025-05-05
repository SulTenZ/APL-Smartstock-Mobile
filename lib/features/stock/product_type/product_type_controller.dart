// lib/features/stock/product_type/product_type_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/product_type_service.dart';

class ProductTypeController extends ChangeNotifier {
  final ProductTypeService _service = ProductTypeService();
  List<dynamic> productTypes = [];
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();

  Future<void> fetchProductTypes() async {
    isLoading = true;
    notifyListeners();
    try {
      productTypes = await _service.getAllProductTypes();
    } catch (e) {
      debugPrint('Error: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProductType(BuildContext context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    try {
      await _service.createProductType(name);
      nameController.clear();
      fetchProductTypes();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan tipe produk')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> deleteProductType(BuildContext context, String id) async {
    try {
      await _service.deleteProductType(id);
      fetchProductTypes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}