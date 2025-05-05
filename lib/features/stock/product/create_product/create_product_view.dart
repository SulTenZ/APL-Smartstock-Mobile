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

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateProductController>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _minStockController.dispose();
    _stockBatchIdController.dispose();
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
    return ChangeNotifierProvider(
      create: (_) => CreateProductController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Produk'),
          backgroundColor: Colors.grey[500],
          elevation: 0,
        ),
        backgroundColor: Colors.grey[100],
        body: Consumer<CreateProductController>(
          builder: (context, controller, child) {
            return controller.isLoading
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

                        CustomFormField(
                          label: 'Nama Produk *',
                          hintText: 'Masukkan nama produk',
                          controller: _namaController, onChanged: (val) {  },
                        ),
                        const SizedBox(height: 16),

                        CustomFormField(
                          label: 'Deskripsi',
                          hintText: 'Masukkan deskripsi produk',
                          controller: _deskripsiController, onChanged: (val) {  },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: CustomFormField(
                                label: 'Harga Beli (Rp) *',
                                hintText: '0',
                                controller: _hargaBeliController,
                                keyboardType: TextInputType.number, onChanged: (val) {  },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomFormField(
                                label: 'Harga Jual (Rp) *',
                                hintText: '0',
                                controller: _hargaJualController,
                                keyboardType: TextInputType.number, onChanged: (val) {  },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        CustomDropDown<int>(
                          label: 'Kategori *',
                          hintText: 'Pilih kategori',
                          value: controller.categoryId,
                          items:
                              controller.categories
                                  .map(
                                    (cat) => DropdownMenuItem(
                                      value: int.parse(cat['id']),
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
                                      value: int.parse(b['id']),
                                      child: Text(b['nama']),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) => controller.brandId = val,
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
                                      value: type['id'] as String,
                                      child: Text(type['name']),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) => controller.setProductType(val),
                        ),

                        const SizedBox(height: 16),

                        CustomFormField(
                          label: 'Stok Minimum',
                          hintText: '0',
                          controller: _minStockController,
                          keyboardType: TextInputType.number, onChanged: (val) {  },
                        ),
                        const SizedBox(height: 16),

                        CustomDropDown<String>(
                          label: 'Kondisi',
                          hintText: 'Pilih kondisi',
                          value: controller.kondisi,
                          items: const [
                            DropdownMenuItem(
                              value: 'Baru',
                              child: Text('Baru'),
                            ),
                            DropdownMenuItem(
                              value: 'Bekas',
                              child: Text('Bekas'),
                            ),
                          ],
                          onChanged: (val) => controller.kondisi = val!,
                        ),
                        const SizedBox(height: 16),

                        CustomFormField(
                          label: 'ID Batch Stok',
                          hintText: 'Opsional',
                          controller: _stockBatchIdController, onChanged: (val) {  },
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
                              final success = await controller.createProduct();
                              if (success) Navigator.pop(context, true);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }
}