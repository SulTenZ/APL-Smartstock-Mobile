// lib/features/stock/product/edit_product/edit_product_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/services/product_service.dart';
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
        appBar: AppBar(title: const Text('Edit Produk')),
        body: isLoadingProduct || product == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Consumer<EditProductController>(
                    builder: (context, controller, _) {
                      return Column(
                        children: [
                          TextFormField(
                            controller: _namaController,
                            decoration: const InputDecoration(labelText: 'Nama Produk'),
                            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                          TextFormField(
                            controller: _hargaBeliController,
                            decoration: const InputDecoration(labelText: 'Harga Beli'),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                          TextFormField(
                            controller: _hargaJualController,
                            decoration: const InputDecoration(labelText: 'Harga Jual'),
                            keyboardType: TextInputType.number,
                            validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                          TextFormField(
                            controller: _minStockController,
                            decoration: const InputDecoration(labelText: 'Minimal Stok'),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
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
                                          SnackBar(content: Text(controller.errorMessage ?? 'Gagal update produk')),
                                        );
                                      }
                                    }
                                  },
                            child: controller.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Simpan Perubahan'),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}