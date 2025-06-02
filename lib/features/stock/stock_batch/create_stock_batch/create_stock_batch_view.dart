// lib/features/stock/stock_batch/create_stock_batch/create_stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_button.dart';
import 'create_stock_batch_controller.dart';

class CreateStockBatchView extends StatelessWidget {
  const CreateStockBatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateStockBatchController(),
      child: const _CreateStockBatchBody(),
    );
  }
}

class _CreateStockBatchBody extends StatelessWidget {
  const _CreateStockBatchBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateStockBatchController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: AbsorbPointer(
              absorbing: controller.isLoading,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
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
                            'TAMBAH BATCH',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF222222),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Form Batch Stok',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Batch
                      CustomFormField(
                        label: 'Nama Batch',
                        hintText: 'Masukkan nama batch',
                        controller: controller.namaController,
                      ),
                      const SizedBox(height: 16),

                      // Total Harga
                      CustomFormField(
                        label: 'Total Harga',
                        hintText: 'Contoh: 2000000',
                        controller: controller.totalHargaController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        ],
                        prefixText: 'Rp ',
                      ),
                      const SizedBox(height: 16),

                      // Jumlah Sepatu
                      CustomFormField(
                        label: 'Jumlah Sepatu',
                        hintText: 'Contoh: 50',
                        controller: controller.jumlahSepatuController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Tombol Simpan
                      CustomButton(
                        text: controller.isLoading ? 'Menyimpan...' : 'Simpan',
                        onPressed: () async {
                          final success = await controller.submit(context);
                          if (success) Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
