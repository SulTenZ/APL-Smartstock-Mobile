// lib/features/transaction_history/transaction_history_controller.dart
import 'package:flutter/material.dart';
import '../../data/services/transaction_service.dart';

class TransactionHistoryController extends ChangeNotifier {
  final TransactionService _service = TransactionService();

  List<Map<String, dynamic>> transactions = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchTransactions() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _service.getAllTransactions();
      transactions = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}

