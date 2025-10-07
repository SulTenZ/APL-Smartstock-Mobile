// lib/features/stock/brand/brand_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'brand_controller.dart';

class BrandView extends StatelessWidget {
  const BrandView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BrandController()..fetchBrands(),
      child: const BrandBody(),
    );
  }
}

class BrandBody extends StatelessWidget {
  const BrandBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BrandController>();

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
                    'BRAND PRODUK',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFF222222)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(context, '/brand/create');
                        if (result == true) controller.fetchBrands();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Consumer<BrandController>(
                  builder: (context, consumerController, child) {
                    if (consumerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (consumerController.brands.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      itemCount: consumerController.brands.length,
                      itemBuilder: (context, index) {
                        final item = consumerController.brands[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: item['image'] != null
                                  ? Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover)
                                  : Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                            ),
                            title: Text(item['nama'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            subtitle: Text(item['deskripsi'] ?? '-', maxLines: 2, overflow: TextOverflow.ellipsis),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                    onPressed: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/brand/edit',
                                        arguments: {
                                          'id': item['id'].toString(),
                                          'nama': item['nama'],
                                          'deskripsi': item['deskripsi'] ?? '',
                                          'image': item['image'] ?? '',
                                        },
                                      );
                                      if (result == true) controller.fetchBrands();
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                    onPressed: () => _confirmDelete(context, controller, item['id'].toString()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
          Icon(Icons.branding_watermark, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Belum ada brand', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(
            'Tambahkan brand produk dengan menekan tombol + di atas',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, BrandController controller, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin menghapus brand ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.deleteBrand(context, id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}