// lib/features/stock/product_type/edit_product_type/edit_product_type_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_button.dart';
import 'edit_product_type_controller.dart';

class EditProductTypeView extends StatelessWidget {
  final String id;
  final String name;

  const EditProductTypeView({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProductTypeController(id: id, initialName: name),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: const Text(
            'Edit Tipe Produk',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<EditProductTypeController>(
            builder: (context, controller, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Form Tipe Produk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  label: 'Nama Tipe Produk',
                  hintText: 'Masukkan nama tipe produk',
                  controller: controller.nameController, onChanged: (val) {  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Perbarui',
                  onPressed: () async {
                    final success = await controller.update(context);
                    if (success) Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
