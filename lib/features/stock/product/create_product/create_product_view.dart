// lib/features/stock/product/create_product/create_product_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '/common/widgets/custom_button.dart';
import '/common/widgets/custom_drop_down.dart';
import '/common/widgets/custom_form.dart';
import 'create_product_controller.dart';

class CreateProductView extends StatefulWidget {
  const CreateProductView({super.key});

  @override
  State<CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<CreateProductView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _minStockController = TextEditingController();
  final _stockBatchIdController = TextEditingController();
  final _jumlahSizeController = TextEditingController();

  String? _selectedSize;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _minStockController.dispose();
    _stockBatchIdController.dispose();
    _jumlahSizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Provider.of<CreateProductController>(
          context,
          listen: false,
        ).setImageFile(File(image.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateProductController>(context);

    final filteredCategories =
        controller.categories.where((cat) {
          if (controller.productTypeId == null) return true;
          return cat['productTypeId'].toString() == controller.productTypeId;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: Colors.grey[500],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            controller.errorMessage!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child:
                              controller.imageFile != null
                                  ? Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.file(
                                          controller.imageFile!,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: controller.clearImageFile,
                                      ),
                                    ],
                                  )
                                  : const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 48,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text('Tambahkan Foto Produk'),
                                      ],
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDown<String>(
                        label: 'Tipe Produk *',
                        hintText: 'Pilih tipe produk',
                        value: controller.productTypeId,
                        items:
                            controller.productTypes
                                .map<DropdownMenuItem<String>>(
                                  (type) => DropdownMenuItem<String>(
                                    value: type['id'].toString(),
                                    child: Text(type['name']),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => controller.setProductType(val),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDown<int>(
                        label: 'Kategori *',
                        hintText: 'Pilih kategori',
                        value: controller.categoryId,
                        items:
                            filteredCategories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: int.tryParse(cat['id'].toString()),
                                    child: Text(cat['nama']),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => controller.categoryId = val,
                      ),
                      const SizedBox(height: 16),
                      CustomDropDown<int>(
                        label: 'Brand *',
                        hintText: 'Pilih brand',
                        value: controller.brandId,
                        items:
                            controller.brands
                                .map(
                                  (b) => DropdownMenuItem(
                                    value: int.tryParse(b['id'].toString()),
                                    child: Text(b['nama']),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => controller.brandId = val,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        label: 'Nama Produk *',
                        hintText: 'Masukkan nama produk',
                        controller: _namaController,
                        onChanged: (val) => controller.nama = val,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        label: 'Deskripsi',
                        hintText: 'Masukkan deskripsi produk',
                        controller: _deskripsiController,
                        onChanged: (val) => controller.deskripsi = val,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomFormField(
                              label: 'Harga Beli (Rp) *',
                              hintText: '0',
                              controller: _hargaBeliController,
                              keyboardType: TextInputType.number,
                              onChanged:
                                  (val) =>
                                      controller.hargaBeli =
                                          double.tryParse(val) ?? 0.0,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomFormField(
                              label: 'Harga Jual (Rp) *',
                              hintText: '0',
                              controller: _hargaJualController,
                              keyboardType: TextInputType.number,
                              onChanged:
                                  (val) =>
                                      controller.hargaJual =
                                          double.tryParse(val) ?? 0.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        label: 'Stok Minimum',
                        hintText: '0',
                        controller: _minStockController,
                        keyboardType: TextInputType.number,
                        onChanged:
                            (val) =>
                                controller.minStock = int.tryParse(val) ?? 0,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Ukuran & Jumlah Stok',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomDropDown<String>(
                              label: 'Ukuran',
                              hintText: 'Pilih ukuran',
                              value: _selectedSize,
                              items:
                                  controller.availableSizes
                                      .map(
                                        (s) => DropdownMenuItem<String>(
                                          value: s['id'].toString(),
                                          child: Text(s['label'].toString()),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) => setState(() => _selectedSize = val),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: CustomFormField(
                              label: 'Jumlah',
                              hintText: '0',
                              keyboardType: TextInputType.number,
                              controller: _jumlahSizeController,
                              onChanged: (val) {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedSize != null &&
                                    _jumlahSizeController.text.isNotEmpty) {
                                  final selected = controller.availableSizes
                                      .firstWhere(
                                        (s) => s['id'] == _selectedSize,
                                      );
                                  final quantity =
                                      int.tryParse(
                                        _jumlahSizeController.text,
                                      ) ??
                                      0;
                                  controller.addSize(
                                    _selectedSize!,
                                    selected['label'],
                                    quantity,
                                  );
                                  _jumlahSizeController.clear();
                                  setState(() => _selectedSize = null);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...controller.sizes.map(
                        (s) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text(s['label'].toString()),
                          ),
                          title: Text('Jumlah: ${s['quantity']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.removeSize(s['sizeId']),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomDropDown<String>(
                        label: 'Kondisi',
                        hintText: 'Pilih kondisi',
                        value: controller.kondisi,
                        items: const [
                          DropdownMenuItem(value: 'BARU', child: Text('BARU')),
                          DropdownMenuItem(
                            value: 'BEKAS',
                            child: Text('BEKAS'),
                          ),
                          DropdownMenuItem(
                            value: 'REKONDISI',
                            child: Text('REKONDISI'),
                          ),
                        ],
                        onChanged: (val) => controller.kondisi = val!,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        label: 'ID Batch Stok',
                        hintText: 'Opsional',
                        controller: _stockBatchIdController,
                        onChanged: (val) => controller.stockBatchId = val,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text:
                            controller.formSubmitting
                                ? 'Menyimpan...'
                                : 'Simpan Produk',
                        isDisabled: controller.formSubmitting,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            controller.nama = _namaController.text.trim();
                            controller.deskripsi =
                                _deskripsiController.text.trim();
                            controller.hargaBeli =
                                double.tryParse(_hargaBeliController.text) ??
                                0.0;
                            controller.hargaJual =
                                double.tryParse(_hargaJualController.text) ??
                                0.0;
                            controller.minStock =
                                int.tryParse(_minStockController.text) ?? 0;
                            controller.stockBatchId =
                                _stockBatchIdController.text.trim();

                            final success = await controller.createProduct();
                            if (success) Navigator.pop(context, true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
