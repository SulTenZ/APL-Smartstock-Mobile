// lib/features/stock/stock_batch/edit_stock_batch/edit_stock_batch_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
      child: _EditForm(id: batch['id'].toString()),
    );
  }
}

class _EditForm extends StatelessWidget {
  final String id;

  const _EditForm({required this.id});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditStockBatchController>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Batch Stok', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.namaController,
              decoration: const InputDecoration(labelText: 'Nama Batch', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.totalHargaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: const InputDecoration(labelText: 'Total Harga', border: OutlineInputBorder(), prefix: Text('Rp ')),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.jumlahSepatuController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Jumlah Sepatu', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        ElevatedButton(
          onPressed: () async {
            final success = await controller.submit(context, id);
            if (success) Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
