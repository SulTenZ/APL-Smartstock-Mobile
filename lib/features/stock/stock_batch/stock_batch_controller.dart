// lib/features/stock/stock_batch/stock_batch_controller.dart
import 'package:flutter/material.dart';
import '../../../data/services/stock_batch_service.dart';

class StockBatchController extends ChangeNotifier {
  final StockBatchService _service = StockBatchService();
  List<Map<String, dynamic>> stockBatches = [];
  bool isLoading = false;

  Future<void> fetchStockBatches() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await _service.getAllStockBatches();
      stockBatches = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('[ERROR] fetchStockBatches: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBatch(BuildContext context, String id) async {
    try {
      await _service.deleteStockBatch(id);
      stockBatches.removeWhere((batch) => batch['id'] == id);
      notifyListeners();
      _showSnackbar(context, 'Batch berhasil dihapus');
    } catch (e) {
      _showSnackbar(context, e.toString());
    }
  }

  String formatCurrency(num value) {
    return 'Rp ${value.toDouble().toStringAsFixed(0)}';
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
