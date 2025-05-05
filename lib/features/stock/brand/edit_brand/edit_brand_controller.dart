// lib/features/stock/brand/edit_brand/edit_brand_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/services/brand_service.dart';

class EditBrandController extends ChangeNotifier {
  final BrandService _service = BrandService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  File? imageFile;

  final String id;

  EditBrandController({required this.id});

  void init(String nama, String deskripsi) {
    namaController.text = nama;
    deskripsiController.text = deskripsi;
  }

  Future<void> pickImage() async {
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

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama brand wajib diisi')),
      );
      return false;
    }

    try {
      await _service.updateBrand(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        imageFile: imageFile,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand berhasil diperbarui')),
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
