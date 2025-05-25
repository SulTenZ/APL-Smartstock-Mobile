// lib/features/transaction_history/transaction_history_detail/transaction_history_detail_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryDetailView extends StatelessWidget {
  final Map<String, dynamic> transaction;
  const TransactionHistoryDetailView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final date = transaction['createdAt'] != null
        ? DateFormat('dd MMM yyyy • HH:mm').format(DateTime.parse(transaction['createdAt']))
        : '-';
    final items = List<Map<String, dynamic>>.from(transaction['items'] ?? []);
    final customer = transaction['customer']?['nama'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Detail Transaksi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Informasi Transaksi
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
                  Text('ID: ${transaction['id'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Tanggal: $date'),
                  Text('Customer: $customer'),
                  Text('Metode: ${transaction['paymentMethod'] ?? "-"}'),
                  if (transaction['catatan'] != null && transaction['catatan'].toString().isNotEmpty)
                    Text('Catatan: ${transaction['catatan']}'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Daftar Produk
            const Text("Daftar Produk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...items.map((item) {
              final product = item['product'] ?? {};
              final size = item['size'] ?? {};
              final sizeLabel = size is Map ? size['label']?.toString() ?? '-' : size.toString();
              final harga = item['hargaJual'] ?? 0;
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
                          Text('Ukuran: $sizeLabel'),
                          Text('Harga Satuan: Rp$harga'),
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
                  rowSummary("Total", transaction['totalAmount']),
                  rowSummary("Diskon", transaction['diskon']),
                  rowSummary("Profit", transaction['profit']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowSummary(String label, dynamic value) => Padding(
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
