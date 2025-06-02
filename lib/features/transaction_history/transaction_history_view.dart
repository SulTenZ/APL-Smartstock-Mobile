// lib/features/transaction_history/transaction_history_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_history_controller.dart';

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionHistoryController()..fetchTransactions(),
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
                      'RIWAYAT TRANSAKSI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // List Content
                Expanded(
                  child: Consumer<TransactionHistoryController>(
                    builder: (context, controller, _) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.errorMessage != null) {
                        return Center(
                          child: Text('Error: ${controller.errorMessage}'),
                        );
                      }
                      if (controller.transactions.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada data transaksi.'),
                        );
                      }
                      return ListView.separated(
                        itemCount: controller.transactions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/transaction-history/detail',
                                arguments: tx,
                              );
                            },
                            child: Container(
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
                                    backgroundColor: Colors.blue.shade50,
                                    child: const Icon(
                                      Icons.receipt_long,
                                      color: Colors.blue,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID: ${tx['id'] ?? '-'}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xFF222222),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Customer: ${tx['customer']?['nama'] ?? '-'}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF666666),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Rp${tx['totalAmount'] ?? 0}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.green,
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
      ),
    );
  }
}
