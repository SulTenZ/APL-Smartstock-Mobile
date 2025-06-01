// lib/features/transaction/transaction_success/transaction_success_controller.dart
import 'package:flutter/material.dart';

class TransactionSuccessController extends ChangeNotifier {
  final String transactionId;
  final String customerName;
  final double totalAmount;
  final List<Map<String, dynamic>> items;
  final String paymentMethod;
  final double discount;
  final String? notes;
  final DateTime transactionDate;

  TransactionSuccessController({
    required this.transactionId,
    required this.customerName,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    this.discount = 0,
    this.notes,
    DateTime? transactionDate,
  }) : transactionDate = transactionDate ?? DateTime.now();

  String get formattedTransactionId {
    return transactionId.length > 12 
        ? transactionId.substring(0, 12)
        : transactionId;
  }

  String get formattedTotal {
    return "Rp. ${totalAmount.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), 
      (Match m) => '${m[1]}.'
    )}";
  }

  String get formattedDate {
    return "${transactionDate.day.toString().padLeft(2, '0')}/"
           "${transactionDate.month.toString().padLeft(2, '0')}/"
           "${transactionDate.year}";
  }

  String get formattedTime {
    return "${transactionDate.hour.toString().padLeft(2, '0')}:"
           "${transactionDate.minute.toString().padLeft(2, '0')}";
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 0));
  }

  void navigateToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}