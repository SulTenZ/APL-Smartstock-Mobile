import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import '../../../common/widgets/custom_drop_down.dart';
import '../transaction_controller.dart';
import 'transaction_submission_controller.dart';
import '../transaction_success/transaction_success_view.dart';

class TransactionSubmissionView extends StatefulWidget {
  const TransactionSubmissionView({super.key});

  @override
  State<TransactionSubmissionView> createState() =>
      _TransactionSubmissionViewState();
}

class _TransactionSubmissionViewState extends State<TransactionSubmissionView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final submitController =
          Provider.of<TransactionSubmissionController>(context, listen: false);
      final cartController =
          Provider.of<TransactionController>(context, listen: false);
      if (submitController.items.isEmpty && cartController.cart.isNotEmpty) {
        submitController
            .setItems(List<Map<String, dynamic>>.from(cartController.cart));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final submitController =
        Provider.of<TransactionSubmissionController>(context, listen: false);
    final cartController =
        Provider.of<TransactionController>(context, listen: false);

    final transactionId = "TX-${DateTime.now().millisecondsSinceEpoch}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Detail Transaksi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text("ID : $transactionId"),
                    const SizedBox(height: 12),

                    CustomFormField(
                      label: "Nama",
                      hintText: "Nama Customer",
                      controller: submitController.namaController,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),
                    CustomFormField(
                      label: "No HP",
                      hintText: "08xxxxxx",
                      controller: submitController.phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 12),

                    Consumer<TransactionSubmissionController>(
                      builder: (context, controller, _) {
                        return Column(
                          children: [
                            CustomDropDown<String>(
                              label: "Metode Pembayaran",
                              hintText: "Pilih Metode",
                              value: controller.selectedPaymentMethod,
                              onChanged: (val) =>
                                  submitController.setPaymentMethod(val),
                              items: const [
                                DropdownMenuItem(
                                    value: 'CASH', child: Text('Cash')),
                                DropdownMenuItem(
                                    value: 'CREDIT_CARD',
                                    child: Text('Kartu Kredit')),
                                DropdownMenuItem(
                                    value: 'DEBIT_CARD',
                                    child: Text('Kartu Debit')),
                                DropdownMenuItem(
                                    value: 'TRANSFER',
                                    child: Text('Transfer Bank')),
                                DropdownMenuItem(
                                    value: 'DIGITAL_WALLET',
                                    child: Text('Dompet Digital')),
                              ],
                            ),
                            const SizedBox(height: 12),
                            CustomFormField(
                              label: "Diskon (Rp)",
                              hintText: "0",
                              controller: controller.diskonController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) {
                                submitController.setItems(controller.items);
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomFormField(
                              label: "Catatan",
                              hintText: "Catatan tambahan untuk transaksi",
                              controller: controller.catatanController,
                              keyboardType: TextInputType.multiline,
                              onChanged: (_) {},
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Item List:",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "📦 Jumlah item: ${controller.items.length}",
                            ),
                            if (controller.items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Belum ada item di keranjang.",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            const SizedBox(height: 8),
                            ...controller.items.map((item) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    if (item['image'] != null)
                                      Image.network(item['image'], width: 60),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Nama: ${item['nama']}"),
                                          Text("Harga: Rp${item['hargaJual']}"),
                                          Text(
                                            "Brand: ${item['brand']?['nama'] ?? '-'}",
                                          ),
                                          Text("Ukuran: ${item['size'] ?? '-'}"),
                                        ],
                                      ),
                                    ),
                                    Text("Jumlah: ${item['quantity']}"),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Subtotal:",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "Rp${controller.items.fold<double>(0.0, (sum, item) => sum + ((item['hargaJual'] ?? 0) * (item['quantity'] ?? 0))).toInt()}",
                                ),
                              ],
                            ),
                            if (controller.diskonController.text.isNotEmpty &&
                                double.tryParse(
                                        controller.diskonController.text) !=
                                    null &&
                                double.tryParse(
                                        controller.diskonController.text)! >
                                    0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Diskon:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Rp${double.tryParse(controller.diskonController.text)?.toStringAsFixed(0) ?? '0'}",
                                  ),
                                ],
                              ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Rp${controller.totalHarga.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Batal",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: "Selesai",
                            onPressed: () async {
                              // --- PERBAIKAN: UNFOCUS KEYBOARD ---
                              FocusScope.of(context).unfocus();

                              if (submitController.items.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Keranjang kosong!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              if (submitController.selectedPaymentMethod ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Pilih metode pembayaran!"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              try {
                                await submitController.submitTransaction();
                                cartController.clearCart();

                                Navigator.of(context).pushReplacement(
                                  PageRouteBuilder(
                                    pageBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                    ) =>
                                        TransactionSuccessView(
                                      transactionId: transactionId,
                                      customerName: submitController
                                              .namaController.text.isEmpty
                                          ? "Customer"
                                          : submitController.namaController.text,
                                      totalAmount: submitController.totalHarga,
                                      items: submitController.items,
                                      paymentMethod:
                                          submitController.selectedPaymentMethod!,
                                      discount: double.tryParse(submitController
                                              .diskonController.text) ??
                                          0,
                                      notes: submitController
                                              .catatanController.text.isEmpty
                                          ? null
                                          : submitController.catatanController.text,
                                    ),
                                    transitionDuration:
                                        const Duration(milliseconds: 800),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 800),
                                    transitionsBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return FadeTransition(
                                        opacity: Tween<double>(
                                          begin: 0.0,
                                          end: 1.0,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Gagal submit transaksi: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}