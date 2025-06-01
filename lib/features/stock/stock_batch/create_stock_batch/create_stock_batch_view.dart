// lib/features/stock/stock_batch/create_stock_batch/create_stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
        return WillPopScope(
          onWillPop: () async => !controller.isLoading,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                                  onPressed: controller.isLoading ? null : () => Navigator.pop(context),
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
                          const Text(
                            'Form Batch Stok',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.namaController,
                            autofocus: true,
                            enabled: !controller.isLoading,
                            decoration: InputDecoration(
                              labelText: 'Nama Batch',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: controller.isLoading ? Colors.grey[200] : Colors.white,
                              prefixIcon: const Icon(Icons.inventory_2_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.totalHargaController,
                            enabled: !controller.isLoading,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Total Harga',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: controller.isLoading ? Colors.grey[200] : Colors.white,
                              prefixIcon: const Icon(Icons.attach_money),
                              helperText: 'Contoh: 2.000.000 atau 2000000',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.jumlahSepatuController,
                            enabled: !controller.isLoading,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Jumlah Sepatu',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: controller.isLoading ? Colors.grey[200] : Colors.white,
                              prefixIcon: const Icon(Icons.confirmation_number_outlined),
                              helperText: 'Masukkan jumlah sepatu dalam batch',
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: controller.isLoading
                                  ? null
                                  : () async {
                                      final success = await controller.submit(context);
                                      if (success) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isLoading ? Colors.grey : Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: controller.isLoading
                                  ? const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Menyimpan...'),
                                      ],
                                    )
                                  : const Text(
                                      'Simpan',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!controller.isLoading)
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.clearForm();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Form telah dibersihkan'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.grey[600],
                                  side: BorderSide(color: Colors.grey[400]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Bersihkan Form',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Menyimpan data...',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
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
