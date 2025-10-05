// lib/features/stock/category/category_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_controller.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryController()..fetchCategories(),
      child: const CategoryBody(),
    );
  }
}

class CategoryBody extends StatelessWidget {
  const CategoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    // [OPTIMASI]: Ambil controller untuk aksi (tanpa listen)
    final controller = context.read<CategoryController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Bagian header yang statis
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
                    'KATEGORI PRODUK',
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
                        final result = await Navigator.pushNamed(context, '/category/create');
                        if (result == true) controller.fetchCategories();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // [OPTIMASI]: Bungkus hanya bagian list dengan Consumer
              Expanded(
                child: Consumer<CategoryController>(
                  builder: (context, consumerController, child) {
                    if (consumerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // Tambahkan pengecekan jika data kosong
                    if (consumerController.categories.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_off_outlined, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text("Belum ada kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey[600])),
                            const SizedBox(height: 8),
                            Text("Tambahkan kategori dengan menekan ikon + di atas", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey[500]))
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: consumerController.categories.length,
                      itemBuilder: (context, index) {
                        final item = consumerController.categories[index];
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.teal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.category_outlined, size: 28, color: Colors.teal),
                            ),
                            title: Text(
                              item['nama'],
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            subtitle: Text(item['deskripsi'] ?? '-', style: const TextStyle(color: Colors.grey)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/category/edit',
                                      arguments: {
                                        'id': item['id'].toString(),
                                        'nama': item['nama'],
                                        'deskripsi': item['deskripsi'] ?? '',
                                        'productTypeId': item['productTypeId'].toString(),
                                      },
                                    );
                                    if (result == true) controller.fetchCategories();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(context, controller, item['id'].toString()),
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

  void _confirmDelete(BuildContext context, CategoryController controller, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Apakah kamu yakin ingin menghapus kategori ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.deleteCategory(context, id);
              // Tidak perlu fetchCategories lagi di sini, karena controller akan notifyListeners
            },
            child: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}