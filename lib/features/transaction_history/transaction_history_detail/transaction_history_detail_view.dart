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
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Info
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${transaction['id'] ?? "-"}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Tanggal: $date'),
                  Text('Customer: $customer'),
                  Text('Metode: ${transaction['paymentMethod'] ?? "-"}'),
                  if (transaction['catatan'] != null && transaction['catatan'].toString().isNotEmpty)
                    Text('Catatan: ${transaction['catatan']}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Items
          const Text("Daftar Produk:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ...items.map((item) {
            final product = item['product'] ?? {};
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: product['image'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(product['image'], width: 48, height: 48, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.image_outlined, size: 48),
                title: Text(product['nama'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qty: ${item['quantity']} | Ukuran: ${item['size'] ?? "-"}'),
                    Text('Harga: Rp${item['hargaJual'] ?? "-"}'),
                    Text('Subtotal: Rp${(item['hargaJual'] ?? 0) * (item['quantity'] ?? 0)}'),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 18),

          // Ringkasan
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  rowSummary("Total", transaction['totalAmount']),
                  rowSummary("Diskon", transaction['diskon']),
                  rowSummary("Profit", transaction['profit']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowSummary(String label, dynamic value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text("Rp${value ?? 0}", style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
