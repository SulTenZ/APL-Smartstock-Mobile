// lib/features/transaction/transaction_submission/transaction_submission_controller.dart
import 'package:flutter/material.dart';
import '../../../../data/services/customer_service.dart';
import '../../../../data/services/transaction_service.dart';

class TransactionSubmissionController extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  final TransactionService _transactionService = TransactionService();

  // Controller untuk form input
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController diskonController = TextEditingController();

  String? selectedPaymentMethod;
  final Map<String, String> paymentMethods = {
    'Tunai': 'CASH',
    'Kartu Kredit': 'CREDIT_CARD',
    'Kartu Debit': 'DEBIT_CARD',
    'Transfer Bank': 'TRANSFER',
    'Dompet Digital': 'DIGITAL_WALLET',
  };

  List<Map<String, dynamic>> items = [];

  double get totalHarga {
    double total = items.fold(
      0,
      (sum, item) => sum + ((item['hargaJual'] ?? 0) * (item['quantity'] ?? 0)),
    );
    
    // Apply discount if available
    double diskon = double.tryParse(diskonController.text) ?? 0;
    return total - diskon;
  }

  void setItems(List<Map<String, dynamic>> newItems) {
    items = newItems;
    notifyListeners();
  }

  void setPaymentMethod(String? method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<void> submitTransaction() async {
    // Validate required fields
    if (selectedPaymentMethod == null || selectedPaymentMethod!.isEmpty) {
      throw Exception('Metode pembayaran harus dipilih');
    }

    // Try to parse discount value, default to 0 if invalid
    double diskon = 0;
    if (diskonController.text.isNotEmpty) {
      diskon = double.tryParse(diskonController.text) ?? 0;
    }

    // Create customer if customer information is provided
    String? customerId;
    if (namaController.text.isNotEmpty) {
      final customer = await _customerService.createCustomer(
        nama: namaController.text,
        // email: emailController.text.isEmpty ? null : emailController.text,
        phone: phoneController.text.isEmpty ? null : phoneController.text,
        // alamat: alamatController.text.isEmpty ? null : alamatController.text,
      );
      customerId = customer['id'];
    }

    // Format items according to the new TransactionService API
    final formattedItems = items.map((item) => {
      'productId': item['id'],
      'quantity': item['quantity'],
      // Add sizeId if it exists
      if (item['sizeId'] != null) 'sizeId': item['sizeId'],
    }).toList();

    // Submit transaction with the new API format
    await _transactionService.createTransaction(
      customerId: customerId,
      paymentMethod: selectedPaymentMethod!,
      diskon: diskon,
      catatan: catatanController.text.isEmpty ? null : catatanController.text,
      items: formattedItems,
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    // emailController.dispose();
    phoneController.dispose();
    // alamatController.dispose();
    catatanController.dispose();
    diskonController.dispose();
    super.dispose();
  }
}