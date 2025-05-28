// lib/features/stock/product/edit_product/edit_product_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/services/product_service.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_form.dart';
import '../edit_product/edit_product_controller.dart';

class EditProductView extends StatefulWidget {
  final String productId;
  const EditProductView({super.key, required this.productId, Map<String, dynamic>? product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaBeliController = TextEditingController();
  final _hargaJualController = TextEditingController();
  final _minStockController = TextEditingController();

  late ProductService _productService;
  Map<String, dynamic>? product;
  bool isLoadingProduct = true;

  @override
  void initState() {
    super.initState();
    _productService = ProductService();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final result = await _productService.getProductById(widget.productId);
      setState(() {
        product = result;
        _namaController.text = result['nama'] ?? '';
        _hargaBeliController.text = result['hargaBeli'].toString();
        _hargaJualController.text = result['hargaJual'].toString();
        _minStockController.text = result['minStock'].toString();
        isLoadingProduct = false;
      });
    } catch (e) {
      setState(() {
        isLoadingProduct = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat produk: $e')));
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _minStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProductController(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: isLoadingProduct || product == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            'EDIT PRODUK',
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
                          'Form Edit Produk',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Consumer<EditProductController>(
                          builder: (context, controller, _) {
                            return Column(
                              children: [
                                CustomFormField(
                                  label: 'Nama Produk',
                                  hintText: 'Masukkan nama produk',
                                  controller: _namaController,
                                  onChanged: (_) {},
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  label: 'Harga Beli',
                                  hintText: 'Masukkan harga beli',
                                  controller: _hargaBeliController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {},
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  label: 'Harga Jual',
                                  hintText: 'Masukkan harga jual',
                                  controller: _hargaJualController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {},
                                ),
                                const SizedBox(height: 16),
                                CustomFormField(
                                  label: 'Minimal Stok',
                                  hintText: 'Masukkan minimal stok',
                                  controller: _minStockController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {},
                                ),
                                const SizedBox(height: 24),
                                CustomButton(
                                  text: 'Simpan Perubahan',
                                  onPressed: controller.isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!.validate()) {
                                            final success = await controller.updateProduct(
                                              id: widget.productId,
                                              nama: _namaController.text,
                                              hargaBeli: double.parse(_hargaBeliController.text),
                                              hargaJual: double.parse(_hargaJualController.text),
                                              categoryId: product!['categoryId'],
                                              brandId: product!['brandId'],
                                              productTypeId: product!['productTypeId'],
                                              minStock: int.tryParse(_minStockController.text),
                                            );
                                            if (success && mounted) {
                                              Navigator.pop(context, true);
                                            } else if (mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(controller.errorMessage ?? 'Gagal update produk'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  isDisabled: controller.isLoading,
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
