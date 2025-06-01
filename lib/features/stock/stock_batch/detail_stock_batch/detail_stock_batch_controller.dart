// lib/features/stock/stock_batch/detail_stock_batch/detail_stock_batch_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/stock_batch_service.dart';

class DetailStockBatchController extends ChangeNotifier {
  final StockBatchService _service = StockBatchService();

  Map<String, dynamic>? batch;
  bool isLoading = true;

  Future<void> fetchDetail(String id) async {
    try {
      isLoading = true;
      notifyListeners();

      batch = await _service.getStockBatchById(id);
    } catch (e) {
      batch = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> get summary => _service.getBatchSummary(batch ?? {});
}
