// lib/features/stock/size/create_size/create_size_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_drop_down.dart';
import '/common/widgets/custom_button.dart';
import 'create_size_controller.dart';

class CreateSizeView extends StatelessWidget {
  const CreateSizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateSizeController()..fetchProductTypes(),
      child: const _CreateSizeBody(),
    );
  }
}

class _CreateSizeBody extends StatelessWidget {
  const _CreateSizeBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateSizeController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          'Tambah Ukuran',
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
                    value: controller.selectedProductTypeId,
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
                      final success = await controller.submit(context);
                      if (success) Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
