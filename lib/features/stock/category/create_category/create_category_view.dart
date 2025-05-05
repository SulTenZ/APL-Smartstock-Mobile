import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_drop_down.dart';
import '/common/widgets/custom_button.dart';
import 'create_category_controller.dart';

class CreateCategoryView extends StatelessWidget {
  const CreateCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateCategoryController()..fetchProductTypes(),
      child: const _CreateCategoryBody(),
    );
  }
}

class _CreateCategoryBody extends StatelessWidget {
  const _CreateCategoryBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateCategoryController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          'Tambah Kategori',
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
                    'Form Kategori',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 16),
                  CustomFormField(
                    label: 'Nama Kategori',
                    hintText: 'Masukkan nama kategori',
                    controller: controller.nameController, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 12),
                  CustomFormField(
                    label: 'Deskripsi',
                    hintText: 'Masukkan deskripsi',
                    controller: controller.descriptionController, onChanged: (val) {  },
                  ),
                  const SizedBox(height: 12),
                  CustomDropDown<String>(
                    label: 'Tipe Produk',
                    hintText: 'Pilih tipe produk',
                    value: controller.selectedProductTypeId,
                    items: controller.productTypes
                        .map((type) {
                          final id = type['id']?.toString();
                          final nama = type['name']?.toString() ?? 'Undefined';
                          if (id == null) return null;
                          return DropdownMenuItem<String>(
                            value: id,
                            child: Text(nama),
                          );
                        })
                        .whereType<DropdownMenuItem<String>>()
                        .toList(),
                    onChanged: (value) {
                      controller.selectedProductTypeId = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Simpan',
                    onPressed: () async {
                      final result = await controller.submit(context);
                      if (result) Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
