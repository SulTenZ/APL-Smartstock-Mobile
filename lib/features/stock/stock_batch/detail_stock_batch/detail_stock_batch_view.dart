// lib/features/stock/stock_batch/detail_stock_batch/detail_stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_stock_batch_controller.dart';

class DetailStockBatchView extends StatelessWidget {
  final String batchId;

  const DetailStockBatchView({super.key, required this.batchId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailStockBatchController()..fetchDetail(batchId),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DetailStockBatchController>(context);
    final batch = controller.batch;
    final summary = controller.summary;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Detail Batch Stok'),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : batch == null
              ? const Center(child: Text('Data batch tidak ditemukan'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem('Nama Batch', batch['nama']),
                      _buildDetailItem('Total Harga', 'Rp ${batch['totalHarga']}'),
                      _buildDetailItem('Jumlah Sepatu', '${batch['jumlahSepatu']} pasang'),
                      _buildDetailItem('Jumlah Produk Masuk', '${summary['totalProducts']}'),
                      _buildDetailItem('Rata-rata Harga / Sepatu', 'Rp ${summary['averageCostPerItem'].toStringAsFixed(0)}'),
                      _buildDetailItem('Sisa Slot', '${summary['remainingSlots']}'),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}