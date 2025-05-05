import 'package:flutter/material.dart';
import '../../../../data/services/category_service.dart';
import '../../../../data/services/product_type_service.dart';

class EditCategoryController extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  final ProductTypeService _productTypeService = ProductTypeService();

  String id;
  String nama;
  String deskripsi;
  String productTypeId;

  bool isLoading = false;
  bool isSaving = false;
  List<dynamic> productTypes = [];

  EditCategoryController({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.productTypeId,
  });

  Future<void> fetchProductTypes() async {
    isLoading = true;
    notifyListeners();

    try {
      productTypes = await _productTypeService.getAllProductTypes();
      debugPrint('Loaded ${productTypes.length} product types');
      debugPrint('Current productTypeId: $productTypeId');

      final exists = productTypes.any((type) => type['id'].toString() == productTypeId);
      debugPrint('Current productTypeId exists in loaded data: $exists');

      if (!exists && productTypes.isNotEmpty) {
        debugPrint('Selected first product type as fallback');
        productTypeId = productTypes.first['id'].toString();
      }
    } catch (e) {
      debugPrint('❌ Error loading product types: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void updateNama(String value) {
    nama = value;
    notifyListeners();
  }

  void updateDeskripsi(String value) {
    deskripsi = value;
    notifyListeners();
  }

  void updateProductTypeId(String value) {
    productTypeId = value;
    notifyListeners();
  }

  Future<bool> saveCategory(BuildContext context) async {
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return false;
    }

    isSaving = true;
    notifyListeners();

    try {
      await _categoryService.updateCategory(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        productTypeId: productTypeId,
      );

      isSaving = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil diperbarui')),
      );
      return true;
    } catch (e) {
      isSaving = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }
}
