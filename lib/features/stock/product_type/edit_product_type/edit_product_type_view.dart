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
      child: const EditProductTypeBody(),
    );
  }
}

class EditProductTypeBody extends StatelessWidget {
  const EditProductTypeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditProductTypeController>(context);

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
                    'EDIT TIPE PRODUK',
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
                  'Form Tipe Produk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Nama Tipe Produk',
                hintText: 'Masukkan nama tipe produk',
                controller: controller.nameController,
                onChanged: (val) {},
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
    );
  }
}
