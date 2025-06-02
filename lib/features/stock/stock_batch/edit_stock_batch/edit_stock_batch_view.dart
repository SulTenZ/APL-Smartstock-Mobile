// lib/features/stock/stock_batch/edit_stock_batch/edit_stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/common/widgets/custom_form.dart';
import '/common/widgets/custom_button.dart';
import 'edit_stock_batch_controller.dart';

class EditStockBatchView extends StatelessWidget {
  final Map<String, dynamic> batch;

  const EditStockBatchView({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditStockBatchController()
        ..namaController.text = batch['nama'] ?? ''
        ..totalHargaController.text = batch['totalHarga']?.toString() ?? ''
        ..jumlahSepatuController.text = batch['jumlahSepatu']?.toString() ?? '',
      child: _EditStockBatchBody(id: batch['id'].toString()),
    );
  }
}

class _EditStockBatchBody extends StatelessWidget {
  final String id;
  const _EditStockBatchBody({required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditStockBatchController>(context);

    return Scaffold(
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
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const Text(
                    'EDIT BATCH STOK',
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

              // Form Fields
              CustomFormField(
                label: 'Nama Batch',
                hintText: 'Masukkan nama batch',
                controller: controller.namaController,
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Total Harga',
                hintText: 'Contoh: 500000',
                controller: controller.totalHargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                ],
                prefixText: 'Rp ',
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Jumlah Sepatu',
                hintText: 'Contoh: 20',
                controller: controller.jumlahSepatuController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),

              // Submit Button
              CustomButton(
                text: 'Perbarui',
                onPressed: () async {
                  final success = await controller.submit(context, id);
                  if (success) Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
