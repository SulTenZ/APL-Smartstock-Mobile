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
      child: const CreateProductTypeBody(),
    );
  }
}

class CreateProductTypeBody extends StatelessWidget {
  const CreateProductTypeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateProductTypeController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    'TAMBAH TIPE PRODUK',
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
    );
  }
} 
