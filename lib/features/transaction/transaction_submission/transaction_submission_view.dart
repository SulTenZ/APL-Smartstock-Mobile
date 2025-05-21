// lib/features/transaction/transaction_submission/transaction_submission_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_form.dart';
import '../../../common/widgets/custom_drop_down.dart';
import '../transaction_controller.dart';
import 'transaction_submission_controller.dart';

class TransactionSubmissionView extends StatelessWidget {
  const TransactionSubmissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionSubmissionController, TransactionController>(
      builder: (context, submitController, cartController, _) {
        // Sinkronisasi items saat halaman pertama kali dibuka
        if (submitController.items.isEmpty && cartController.cart.isNotEmpty) {
          submitController.setItems(
            List<Map<String, dynamic>>.from(cartController.cart),
          );
        }

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
                          label: "Email",
                          hintText: "Email Customer",
                          controller: submitController.emailController,
                          keyboardType: TextInputType.emailAddress,
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
                        CustomFormField(
                          label: "Alamat",
                          hintText: "Alamat Customer",
                          controller: submitController.alamatController,
                          keyboardType: TextInputType.multiline,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 12),
                        CustomDropDown<String>(
                          label: "Metode Pembayaran",
                          hintText: "Pilih Metode",
                          value: submitController.selectedPaymentMethod,
                          onChanged:
                              (val) => submitController.setPaymentMethod(val),
                          items: const [
                            DropdownMenuItem(
                              value: 'CASH',
                              child: Text('Cash'),
                            ),
                            DropdownMenuItem(
                              value: 'CREDIT_CARD',
                              child: Text('Kartu Kredit'),
                            ),
                            DropdownMenuItem(
                              value: 'DEBIT_CARD',
                              child: Text('Kartu Debit'),
                            ),
                            DropdownMenuItem(
                              value: 'TRANSFER',
                              child: Text('Transfer Bank'),
                            ),
                            DropdownMenuItem(
                              value: 'DIGITAL_WALLET',
                              child: Text('Dompet Digital'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Tambahkan field untuk diskon
                        CustomFormField(
                          label: "Diskon (Rp)",
                          hintText: "0",
                          controller: submitController.diskonController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            // Trigger refresh tampilan agar total terupdate
                            // Gunakan controller method (misal setState/notify melalui Provider/ChangeNotifier)
                            submitController.setItems(submitController.items);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Tambahkan field untuk catatan
                        CustomFormField(
                          label: "Catatan",
                          hintText: "Catatan tambahan untuk transaksi",
                          controller: submitController.catatanController,
                          keyboardType: TextInputType.multiline,
                          // maxLines dihapus karena tidak tersedia di CustomFormField-mu
                          onChanged: (_) {},
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          "Item List:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "📦 Jumlah item: ${submitController.items.length}",
                        ),
                        if (submitController.items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Belum ada item di keranjang.",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        const SizedBox(height: 8),
                        ...submitController.items.map((item) {
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
                              "Rp${submitController.items.fold<double>(0.0, (sum, item) => sum + ((item['hargaJual'] ?? 0) * (item['quantity'] ?? 0))).toInt()}",
                            ),
                          ],
                        ),
                        if (submitController.diskonController.text.isNotEmpty &&
                            double.tryParse(
                                  submitController.diskonController.text,
                                ) !=
                                null &&
                            double.tryParse(
                                  submitController.diskonController.text,
                                )! >
                                0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Diskon:",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Rp${double.tryParse(submitController.diskonController.text)?.toStringAsFixed(0) ?? '0'}",
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
                              "Rp${submitController.totalHarga.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
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
                                        content: Text(
                                          "Pilih metode pembayaran!",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  try {
                                    await submitController.submitTransaction();
                                    cartController.clearCart();
                                    Navigator.popUntil(
                                      context,
                                      (route) => route.isFirst,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Transaksi berhasil!"),
                                        backgroundColor: Colors.green,
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
      },
    );
  }
}
