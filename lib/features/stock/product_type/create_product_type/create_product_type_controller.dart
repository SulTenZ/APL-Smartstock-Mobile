// lib/features/stock/product_type/create_product_type/create_product_type_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/product_type_service.dart';

class CreateProductTypeController extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final ProductTypeService _service = ProductTypeService();

  Future<bool> submit(BuildContext context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) return false;

    try {
      await _service.createProductType(name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipe produk berhasil ditambahkan')),
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
    super.dispose();
  }
}