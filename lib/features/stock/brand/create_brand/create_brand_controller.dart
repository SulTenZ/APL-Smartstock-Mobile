// lib/features/stock/brand/create_brand/create_brand_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../data/services/brand_service.dart';
import 'package:image_picker/image_picker.dart';

class CreateBrandController extends ChangeNotifier {
  final BrandService _service = BrandService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  File? imageFile;
  bool isLoading = false;

  void pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile = File(picked.path);
      notifyListeners();
    }
  }

  Future<bool> submit(BuildContext context) async {
    final nama = namaController.text.trim();
    final deskripsi = deskripsiController.text.trim();

    if (nama.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Gambar wajib diisi')),
      );
      return false;
    }

    print("🧾 Nama: $nama");
    print("📝 Deskripsi: $deskripsi");
    print("🖼️ Path gambar: ${imageFile?.path}");
    print("📦 Ukuran file (bytes): ${await imageFile!.length()}");

    try {
      await _service.createBrand(
        nama: nama,
        deskripsi: deskripsi,
        imageFile: imageFile!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand berhasil ditambahkan')),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return false;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }
}
