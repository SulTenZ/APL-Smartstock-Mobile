// lib/features/stock/product_type/create_product_type/create_product_type_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_button.dart';
import 'create_product_type_controller.dart';

class CreateProductTypeView extends StatelessWidget {
  const CreateProductTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateProductTypeController(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[500],
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: const Text(
            'Tambah Tipe Produk',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<CreateProductTypeController>(
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
                  text: 'Simpan',
                  onPressed: () async {
                    final success = await controller.submit(context);
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