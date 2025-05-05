// lib/features/stock/product_type/edit_product_type/edit_product_type_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/product_type_service.dart';

class EditProductTypeController extends ChangeNotifier {
  final ProductTypeService _service = ProductTypeService();
  final TextEditingController nameController = TextEditingController();
  final String id;

  EditProductTypeController({required this.id, required String initialName}) {
    nameController.text = initialName;
  }

  Future<bool> update(BuildContext context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) return false;

    try {
      await _service.updateProductType(id, name);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipe produk berhasil diperbarui')),
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
