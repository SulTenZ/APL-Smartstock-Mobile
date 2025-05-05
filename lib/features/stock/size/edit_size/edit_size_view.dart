// lib/features/stock/size/edit_size/edit_size_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_drop_down.dart';
import '/common/widgets/custom_button.dart';
import 'edit_size_controller.dart';

class EditSizeView extends StatelessWidget {
  final String id;
  final String label;
  final String productTypeId;

  const EditSizeView({
    super.key,
    required this.id,
    required this.label,
    required this.productTypeId,
    required initialLabel,
    required initialProductTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditSizeController()
        ..labelController.text = label
        ..selectedProductTypeId = productTypeId
        ..fetchProductTypes(),
      child: _EditSizeBody(id: id),
    );
  }
}

class _EditSizeBody extends StatelessWidget {
  final String id;

  const _EditSizeBody({required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditSizeController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          'Edit Ukuran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Ukuran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    label: 'Label Ukuran',
                    hintText: 'Masukkan label ukuran',
                    controller: controller.labelController, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 16),
                  CustomDropDown<String>(
                    label: 'Tipe Produk',
                    hintText: 'Pilih tipe produk',
                    value: controller.productTypes.map((e) => e['id'].toString()).contains(controller.selectedProductTypeId)
                        ? controller.selectedProductTypeId
                        : null,
                    items: controller.productTypes.map((type) {
                      final id = type['id']?.toString();
                      final name = type['name']?.toString() ?? 'Undefined';
                      if (id == null) return null;
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(name),
                      );
                    }).whereType<DropdownMenuItem<String>>().toList(),
                    onChanged: (value) => controller.selectedProductTypeId = value,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Simpan',
                    onPressed: () async {
                      final success = await controller.submit(context, id);
                      if (success) Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}