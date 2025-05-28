// lib/features/stock/category/create_category/create_category_view.dart
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const Text(
                    'TAMBAH KATEGORI',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Form Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Nama Kategori',
                hintText: 'Masukkan nama kategori',
                controller: controller.nameController,
                onChanged: (val) {},
              ),
              const SizedBox(height: 12),
              CustomFormField(
                label: 'Deskripsi',
                hintText: 'Masukkan deskripsi',
                controller: controller.descriptionController,
                onChanged: (val) {},
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
      ),
    );
  }
}
