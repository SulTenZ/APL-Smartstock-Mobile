// lib/features/stock/product/detail_product/detail_product_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_product_controller.dart';
import '../edit_product/edit_product_view.dart';
import '../../../../data/services/size_service.dart';

class DetailProductView extends StatefulWidget {
  final String productId;

  const DetailProductView({super.key, required this.productId});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  final SizeService _sizeService = SizeService();
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailProductController(),
      child: Consumer<DetailProductController>(
        builder: (context, controller, child) {
          if (!_isInitialized) {
            _isInitialized = true;
            controller.getProductDetails(widget.productId);
          }

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
                          'DETAIL PRODUK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF222222),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductView(
                                    productId: widget.productId,
                                    product: controller.product,
                                  ),
                                ),
                              );

                              if (result == true) {
                                controller.getProductDetails(widget.productId);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(child: _buildBody(controller)),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.grey[500],
              onPressed: () => _showAddSizeDialog(context, controller),
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Tambah Ukuran',
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }
  Widget _buildBody(DetailProductController controller) {
    if (controller.isLoading && controller.product == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.errorMessage ?? 'Produk tidak ditemukan',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.getProductDetails(widget.productId),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final product = controller.product!;

    return RefreshIndicator(
      onRefresh: () => controller.getProductDetails(widget.productId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image'] != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    product['image'],
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 64),
                      );
                    },
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(Icons.image, size: 64),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              product['nama'] ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildCard('Harga Beli', 'Rp${product['hargaBeli'] ?? '0'}')),
                Expanded(child: _buildCard('Harga Jual', 'Rp${product['hargaJual'] ?? '0'}')),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildCard(
                    'Total Stok',
                    controller.calculateTotalStock().toString(),
                    textColor: controller.isLowStock() ? Colors.red : Colors.green,
                  ),
                ),
                Expanded(child: _buildCard('Minimum Stok', product['minStock'].toString())),
              ],
            ),
            const SizedBox(height: 16),
            _buildProductInfo(product),
            const SizedBox(height: 16),
            const Text('Ukuran dan Stok', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildSizeList(product, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, {Color? textColor}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ]),
      ),
    );
  }

  Widget _buildProductInfo(Map<String, dynamic> product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Informasi Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildInfoRow('Kategori', product['category']?['nama'] ?? '-'),
          _buildInfoRow('Brand', product['brand']?['nama'] ?? '-'),
          _buildInfoRow('Tipe Produk', product['productType']?['name'] ?? '-'),
          _buildInfoRow('Kondisi', product['kondisi'] ?? '-'),
          _buildInfoRow('Deskripsi', product['deskripsi'] ?? '-'),
        ]),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildSizeList(Map<String, dynamic> product, DetailProductController controller) {
    final sizes = product['sizes'] as List?;
    if (sizes == null || sizes.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('Belum ada data ukuran', style: TextStyle(color: Colors.grey))),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final size = sizes[index];
        return Card(
          child: ListTile(
            title: Text(size['size']?['label'] ?? 'Ukuran tidak diketahui',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Stok: ${size['quantity'] ?? 0}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showUpdateSizeDialog(
                    context,
                    controller,
                    size['id'],
                    size['size']?['label'],
                    size['quantity'] ?? 0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteSizeConfirmation(
                    context,
                    controller,
                    size['size']?['id'],
                    size['size']?['label'],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Show dialog to add a new size
  Future<void> _showAddSizeDialog(BuildContext context, DetailProductController controller) async {
    String? selectedSizeId;
    int quantity = 1;
    List<dynamic> availableSizes = [];
    bool isLoading = false;
    String? productTypeId = controller.product?['productTypeId'];
    
    if (productTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipe produk tidak diketahui')),
      );
      return;
    }
    
    // Load available sizes for the product type
    try {
      final result = await _sizeService.getAllSizes(productTypeId: productTypeId);
      availableSizes = result['data'];
      
      // Filter out sizes that are already added to the product
      final existingSizes = controller.product?['sizes'] ?? [];
      final existingSizeIds = existingSizes.map((s) => s['size']?['id']).toList();
      availableSizes = availableSizes.where((s) => !existingSizeIds.contains(s['id'])).toList();
      
      if (availableSizes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Semua ukuran sudah ditambahkan')),
        );
        return;
      }
      
      selectedSizeId = availableSizes.first['id'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat ukuran: ${e.toString()}')),
      );
      return;
    }
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tambah Ukuran'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedSizeId,
                        decoration: const InputDecoration(
                          labelText: 'Ukuran',
                          border: OutlineInputBorder(),
                        ),
                        items: availableSizes.map<DropdownMenuItem<String>>((size) {
                          return DropdownMenuItem<String>(
                            value: size['id'],
                            child: Text(size['label']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSizeId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Jumlah',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: quantity.toString(),
                        onChanged: (value) {
                          setState(() {
                            quantity = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: isLoading || selectedSizeId == null ? null : () async {
                  setState(() {
                    isLoading = true;
                  });
                  
                  final success = await controller.addProductSize(
                    productId: widget.productId,
                    sizeId: selectedSizeId!,
                    quantity: quantity,
                  );
                  
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ukuran berhasil ditambahkan')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(controller.errorMessage ?? 'Gagal menambahkan ukuran')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  // Show dialog to update size quantity
  Future<void> _showUpdateSizeDialog(
    BuildContext context,
    DetailProductController controller,
    String? productSizeId, // Change to productSizeId
    String? sizeLabel,
    int currentQuantity,
  ) async {
    if (productSizeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID ukuran tidak valid')),
      );
      return;
    }
    
    int quantity = currentQuantity;
    bool isLoading = false;
    
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Update Stok ${sizeLabel ?? ''}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: quantity.toString(),
                    onChanged: (value) {
                      setState(() {
                        quantity = int.tryParse(value) ?? currentQuantity;
                      });
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  setState(() {
                    isLoading = true;
                  });
                  
                  final success = await controller.updateProductSize(
                    productSizeId: productSizeId, // Updated parameter name
                    quantity: quantity,
                  );
                  
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Stok berhasil diperbarui')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(controller.errorMessage ?? 'Gagal memperbarui stok')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
  
  // Show confirmation dialog for deleting a size
  Future<void> _showDeleteSizeConfirmation(
    BuildContext context,
    DetailProductController controller,
    String? sizeId,
    String? sizeLabel,
  ) async {
    if (sizeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID ukuran tidak valid')),
      );
      return;
    }
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus ukuran ${sizeLabel ?? ''}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final success = await controller.deleteProductSize(
                productId: widget.productId,
                sizeId: sizeId,
              );
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ukuran berhasil dihapus')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(controller.errorMessage ?? 'Gagal menghapus ukuran')),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}