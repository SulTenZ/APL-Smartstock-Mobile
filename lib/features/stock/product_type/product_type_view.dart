// lib/features/stock/product_type/product_type_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_type_controller.dart';

class ProductTypeView extends StatelessWidget {
  const ProductTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductTypeController()..fetchProductTypes(),
      child: const ProductTypeBody(),
    );
  }
}

class ProductTypeBody extends StatelessWidget {
  const ProductTypeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ProductTypeController>();

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
                    'TIPE PRODUK',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black, size: 28),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/product-type/create');
                        if (result == true) {
                          controller.fetchProductTypes();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Consumer<ProductTypeController>(
                  builder: (context, consumerController, child) {
                    if (consumerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (consumerController.productTypes.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildProductTypeList(context, controller, consumerController.productTypes);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("Belum ada tipe produk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text("Tambahkan tipe produk dengan menekan ikon + di atas", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[500]))
        ],
      ),
    );
  }

  Widget _buildProductTypeList(BuildContext context, ProductTypeController actionController, List<dynamic> productTypes) {
    return ListView.builder(
      itemCount: productTypes.length,
      itemBuilder: (context, index) {
        final item = productTypes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.category, size: 28, color: Colors.indigo),
            ),
            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.blue,
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/product-type/edit',
                      arguments: {
                        'id': item['id'].toString(),
                        'name': item['name'],
                      },
                    );
                    if (result == true) actionController.fetchProductTypes();
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () => _confirmDelete(context, actionController, item['id'].toString()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: IconButton(icon: Icon(icon, size: 20, color: color), onPressed: onTap),
    );
  }

  void _confirmDelete(BuildContext context, ProductTypeController controller, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin menghapus tipe produk ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.deleteProductType(context, id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}