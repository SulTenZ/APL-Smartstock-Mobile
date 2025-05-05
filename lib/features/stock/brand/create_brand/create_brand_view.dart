// lib/features/stock/brand/create_brand/create_brand_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_button.dart';
import 'create_brand_controller.dart';

class CreateBrandView extends StatelessWidget {
  const CreateBrandView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateBrandController(),
      child: const _CreateBrandBody(),
    );
  }
}

class _CreateBrandBody extends StatelessWidget {
  const _CreateBrandBody();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateBrandController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: const Text('Tambah Brand', style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Form Brand',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            CustomFormField(
              label: 'Nama Brand',
              hintText: 'Masukkan nama brand',
              controller: controller.namaController, onChanged: (val) {  },
            ),
            const SizedBox(height: 12),
            CustomFormField(
              label: 'Deskripsi',
              hintText: 'Masukkan deskripsi',
              controller: controller.deskripsiController, onChanged: (val) {  },
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: controller.imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(controller.imageFile!, fit: BoxFit.cover),
                      )
                    : const Center(child: Text('Tap untuk memilih gambar')),
              ),
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
