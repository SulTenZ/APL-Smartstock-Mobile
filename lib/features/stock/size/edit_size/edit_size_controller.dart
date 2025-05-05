// lib/features/stock/size/edit_size/edit_size_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/size_service.dart';
import '../../../../data/services/product_type_service.dart';

class EditSizeController extends ChangeNotifier {
  final SizeService _sizeService = SizeService();
  final ProductTypeService _productTypeService = ProductTypeService();

  final TextEditingController labelController = TextEditingController();

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

  Future<bool> submit(BuildContext context, String id) async {
    final label = labelController.text.trim();

    if (label.isEmpty || _selectedProductTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Label dan Tipe Produk wajib diisi')),
      );
      return false;
    }

    try {
      await _sizeService.updateSize(
        id,
        label,
        _selectedProductTypeId!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ukuran berhasil diperbarui')),
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
    labelController.dispose();
    super.dispose();
  }
}
