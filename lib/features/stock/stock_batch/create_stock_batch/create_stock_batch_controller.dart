// lib/features/stock/stock_batch/create_stock_batch/create_stock_batch_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/stock_batch_service.dart';

class CreateStockBatchController extends ChangeNotifier {
  final StockBatchService _service = StockBatchService();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController totalHargaController = TextEditingController();
  final TextEditingController jumlahSepatuController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> submit(BuildContext context) async {
    final nama = namaController.text.trim();
    final totalHargaText = totalHargaController.text.trim();
    final jumlahSepatuText = jumlahSepatuController.text.trim();

    if (nama.isEmpty) {
      _showSnackbar(context, 'Nama batch tidak boleh kosong', isError: true);
      return false;
    }
    if (totalHargaText.isEmpty) {
      _showSnackbar(context, 'Total harga tidak boleh kosong', isError: true);
      return false;
    }
    if (jumlahSepatuText.isEmpty) {
      _showSnackbar(context, 'Jumlah sepatu tidak boleh kosong', isError: true);
      return false;
    }

    final totalHarga = double.tryParse(
      totalHargaText.replaceAll('.', '').replaceAll(',', '.'),
    );
    final jumlahSepatu = int.tryParse(jumlahSepatuText);

    debugPrint('[DEBUG] totalHargaText: $totalHargaText => parsed: $totalHarga');

    if (totalHarga == null || totalHarga <= 0) {
      _showSnackbar(context, 'Total harga harus berupa angka dan lebih dari 0', isError: true);
      return false;
    }
    if (jumlahSepatu == null || jumlahSepatu <= 0) {
      _showSnackbar(context, 'Jumlah sepatu harus berupa angka dan lebih dari 0', isError: true);
      return false;
    }

    setLoading(true);

    try {
      _showSnackbar(context, 'Menyimpan batch...', isError: false);

      await _service.createStockBatch(
        nama: nama,
        totalHarga: totalHarga,
        jumlahSepatu: jumlahSepatu,
      );

      _showSnackbar(context, 'Batch berhasil disimpan!', isError: false);
      return true;
    } catch (e) {
      debugPrint('[ERROR] Submit failed: $e');
      final message = e.toString().replaceFirst('Exception: ', '');
      _showSnackbar(context, message, isError: true);
      return false;
    } finally {
      setLoading(false);
    }
  }

  void _showSnackbar(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 2),
        behavior: SnackBarBehavior.floating,
        action: isError
            ? SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              )
            : null,
      ),
    );
  }

  void clearForm() {
    namaController.clear();
    totalHargaController.clear();
    jumlahSepatuController.clear();
  }

  @override
  void dispose() {
    namaController.dispose();
    totalHargaController.dispose();
    jumlahSepatuController.dispose();
    super.dispose();
  }
}