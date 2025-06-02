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
    final items = controller.items;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : batch == null
                ? const Center(child: Text('Data batch tidak ditemukan'))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        // Custom AppBar
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
                              'DETAIL BATCH STOK',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Informasi Umum
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${batch['id'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('Nama Batch: ${batch['nama']}'),
                              Text('Jumlah Sepatu: ${batch['jumlahSepatu']} pasang'),
                              Text('Total Harga: Rp ${batch['totalHarga']}'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text("Daftar Produk Masuk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),

                        ...items.map((item) {
                          final product = item['product'] ?? {};
                          final size = item['size'] ?? {};
                          final label = size is Map ? size['label']?.toString() ?? '-' : size.toString();
                          final harga = item['hargaBeli'] ?? 0;
                          final quantity = item['quantity'] ?? 0;
                          final subtotal = harga * quantity;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                product['image'] != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(product['image'], width: 48, height: 48, fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.image_outlined, size: 48),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product['nama'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 6),
                                      Text('Jumlah: $quantity'),
                                      Text('Ukuran: $label'),
                                      Text('Harga Beli: Rp$harga'),
                                      Text('Subtotal: Rp$subtotal'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 24),

                        // Ringkasan
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _rowSummary("Jumlah Produk", summary['totalProducts']),
                              _rowSummary("Rata-rata Harga / Sepatu", summary['averageCostPerItem']),
                              _rowSummary("Sisa Slot", summary['remainingSlots']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _rowSummary(String label, dynamic value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text("Rp${value ?? 0}", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      );
}
