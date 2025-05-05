// lib/features/stock/category/create_category/create_category_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/product_type_service.dart';

class CreateCategoryController extends ChangeNotifier {
  final CategoryService _service = CategoryService();
  final ProductTypeService _productTypeService = ProductTypeService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> productTypes = [];
  bool isLoading = false;

  String? _selectedProductTypeId;
  String? get selectedProductTypeId => _selectedProductTypeId;

  set selectedProductTypeId(String? value) {
    _selectedProductTypeId = value;
    notifyListeners();
  }

  Future<void> fetchProductTypes() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _productTypeService.getAllProductTypes();
      productTypes = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint("Gagal mengambil tipe produk: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> submit(BuildContext context) async {
    final name = nameController.text.trim();
    final desc = descriptionController.text.trim();

    if (name.isEmpty || _selectedProductTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Tipe Produk wajib diisi')),
      );
      return false;
    }

    try {
      await _service.createCategory(
        nama: name,
        deskripsi: desc,
        productTypeId: _selectedProductTypeId!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil ditambahkan')),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
