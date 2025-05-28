// lib/features/stock/category/edit_category/edit_category_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_drop_down.dart';
import '/common/widgets/custom_button.dart';
import 'edit_category_controller.dart';

class EditCategoryView extends StatelessWidget {
  final String id;
  final String nama;
  final String deskripsi;
  final String productTypeId;

  const EditCategoryView({
    super.key,
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.productTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditCategoryController(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        productTypeId: productTypeId,
      )..fetchProductTypes(),
      child: const EditCategoryBody(),
    );
  }
}

class EditCategoryBody extends StatefulWidget {
  const EditCategoryBody({super.key});

  @override
  State<EditCategoryBody> createState() => _EditCategoryBodyState();
}

class _EditCategoryBodyState extends State<EditCategoryBody> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<EditCategoryController>(context, listen: false);
    _namaController = TextEditingController(text: controller.nama);
    _deskripsiController = TextEditingController(text: controller.deskripsi);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditCategoryController>(context);

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
                    'EDIT KATEGORI',
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
                controller: _namaController,
                onChanged: (val) => controller.updateNama(val),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Deskripsi',
                hintText: 'Masukkan deskripsi',
                controller: _deskripsiController,
                onChanged: (val) => controller.updateDeskripsi(val),
              ),
              const SizedBox(height: 16),
              CustomDropDown<String>(
                label: 'Tipe Produk',
                hintText: 'Pilih tipe produk',
                value: controller.productTypes.any((type) => type['id'].toString() == controller.productTypeId)
                    ? controller.productTypeId
                    : null,
                items: controller.productTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['id'].toString(),
                    child: Text(type['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.updateProductTypeId(value);
                },
              ),
              const SizedBox(height: 24),
              controller.isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'Simpan',
                      onPressed: () async {
                        controller.updateNama(_namaController.text);
                        controller.updateDeskripsi(_deskripsiController.text);
                        final result = await controller.saveCategory(context);
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
