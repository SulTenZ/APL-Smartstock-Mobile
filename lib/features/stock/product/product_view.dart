// lib/features/stock/product/product_view.dart
import 'package:alp_shoes_secondbrand_mobile/features/stock/product/create_product/create_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_controller.dart';
import 'create_product/create_product_view.dart';
import 'detail_product/detail_product_view.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductController>(context, listen: false).getProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        backgroundColor: Colors.grey[500],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari produk...'
                  ),
                  onSubmitted: (value) => controller.searchProducts(value),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.products.isEmpty
                          ? const Center(child: Text('Tidak ada produk yang tersedia'))
                          : ListView.builder(
                              itemCount: controller.products.length,
                              itemBuilder: (context, index) {
                                final product = controller.products[index];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: product['image'] != null
                                          ? Image.network(
                                              product['image'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.image_not_supported),
                                            ),
                                    ),
                                    title: Text(
                                      product['nama'] ?? '-',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Rp${product['hargaJual'] ?? 0}'),
                                        Text(
                                          'Stok: ${_calculateTotalStock(product)}',
                                          style: TextStyle(
                                            color: _calculateTotalStock(product) <= (product['minStock'] ?? 0)
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.arrow_forward_ios),
                                          onPressed: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DetailProductView(productId: product['id']),
                                              ),
                                            );
                                            controller.getProducts(refresh: true);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Hapus Produk'),
                                                content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    child: const Text('Hapus'),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              final success = await controller.deleteProduct(product['id']);
                                              if (success) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Produk berhasil dihapus')),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Gagal menghapus produk: ${controller.errorMessage ?? 'Terjadi kesalahan'}')),
                                                );
                                              }
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
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[500],
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => CreateProductController()..init(),
                child: const CreateProductView()
              ),
            ),
          );
          if (result == true) {
            Provider.of<ProductController>(context, listen: false).getProducts(refresh: true);
          }
        },
      ),
    );
  }

  int _calculateTotalStock(dynamic product) {
    if (product['sizes'] == null) return 0;
    final sizes = List<Map<String, dynamic>>.from(product['sizes']);
    return sizes.fold<num>(0, (total, size) => total + (size['quantity'] ?? 0)).toInt();
  }
}