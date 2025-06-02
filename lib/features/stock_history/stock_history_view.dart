// lib/features/stock_history/stock_history_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stock_history_controller.dart';

class StockHistoryView extends StatelessWidget {
  const StockHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockHistoryController()..fetchStockHistory(),
      child: Scaffold(
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
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const Text(
                      'RIWAYAT STOK MASUK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Consumer<StockHistoryController>(
                    builder: (context, controller, _) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.errorMessage != null) {
                        return Center(child: Text('Error: ${controller.errorMessage}'));
                      }
                      if (controller.stockHistory.isEmpty) {
                        return const Center(child: Text('Tidak ada riwayat stok.'));
                      }
                      return ListView.separated(
                        itemCount: controller.stockHistory.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = controller.stockHistory[index];
                          final createdAt = product['createdAt'];
                          final dateStr = createdAt != null
                              ? DateTime.tryParse(createdAt)?.toLocal().toString().split(' ').first
                              : '-';
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.orange.shade50,
                                  child: const Icon(
                                    Icons.inventory_2,
                                    color: Colors.orange,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['nama'] ?? '-',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Color(0xFF222222),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Ditambahkan: $dateStr',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Stok: ${product['stock'] ?? 0}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
