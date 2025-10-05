// lib/features/stock/stock_batch/stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_batch_controller.dart';

class StockBatchView extends StatelessWidget {
  const StockBatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockBatchController()..fetchStockBatches(),
      child: const _StockBatchBody(),
    );
  }
}

class _StockBatchBody extends StatelessWidget {
  const _StockBatchBody();

  @override
  Widget build(BuildContext context) {
    // [OPTIMASI]: Ambil controller untuk aksi (tanpa listen)
    final controller = context.read<StockBatchController>();

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
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const Text(
                    'BATCH STOK',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF222222),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/stock-batch/create',
                        );
                        if (result == true) controller.fetchStockBatches();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // [OPTIMASI]: Bungkus hanya bagian list dengan Consumer
              Expanded(
                child: Consumer<StockBatchController>(
                  builder: (context, consumerController, child) {
                    if (consumerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (consumerController.stockBatches.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      itemCount: consumerController.stockBatches.length,
                      itemBuilder: (context, index) {
                        final batch = consumerController.stockBatches[index];
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
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/stock-batch/detail',
                                arguments: {'id': batch['id'].toString()},
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.layers,
                                size: 28,
                                color: Colors.indigo,
                              ),
                            ),
                            title: Text(
                              batch['nama'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'Jumlah sepatu: ${batch['jumlahSepatu']} | Total harga: Rp ${controller.formatCurrency(batch['totalHarga'])}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.pushNamed(
                                        context,
                                        '/stock-batch/edit',
                                        arguments: {'batch': batch},
                                      );
                                      if (result == true) {
                                        controller.fetchStockBatches();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: const Text(
                                            'Konfirmasi Hapus',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                              'Apakah kamu yakin ingin menghapus batch stok ini?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(ctx).pop(),
                                              child: const Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                                controller.deleteBatch(
                                                  context,
                                                  batch['id'].toString(),
                                                );
                                              },
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
          Icon(Icons.layers_clear, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada batch stok',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan batch stok dengan menekan tombol + di atas',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}