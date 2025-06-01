// lib/features/stock/stock_batch/edit_stock_batch/edit_stock_batch_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/stock_batch_service.dart';

class EditStockBatchController extends ChangeNotifier {
  final StockBatchService _service = StockBatchService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController totalHargaController = TextEditingController();
  final TextEditingController jumlahSepatuController = TextEditingController();

  Future<void> loadData(String id) async {
    try {
      final data = await _service.getStockBatchById(id);
      namaController.text = data['nama'] ?? '';
      totalHargaController.text = data['totalHarga']?.toString() ?? '';
      jumlahSepatuController.text = data['jumlahSepatu']?.toString() ?? '';
    } catch (_) {}
  }

  Future<bool> submit(BuildContext context, String id) async {
    final nama = namaController.text.trim();
    final totalHarga = double.tryParse(totalHargaController.text.trim());
    final jumlahSepatu = int.tryParse(jumlahSepatuController.text.trim());

    if (nama.isEmpty || totalHarga == null || jumlahSepatu == null) {
      _showSnackbar(context, 'Semua field wajib diisi');
      return false;
    }

    try {
      await _service.updateStockBatch(
        id: id,
        nama: nama,
        totalHarga: totalHarga,
        jumlahSepatu: jumlahSepatu,
      );
      return true;
    } catch (e) {
      _showSnackbar(context, e.toString());
      return false;
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    namaController.dispose();
    totalHargaController.dispose();
    jumlahSepatuController.dispose();
    super.dispose();
  }
}
