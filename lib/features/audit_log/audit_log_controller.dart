// lib/features/audit_log/audit_log_controller.dart
import 'dart:convert'; // Import untuk jsonEncode
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/services/audit_log_service.dart';

class AuditLogController with ChangeNotifier {
  final AuditLogService _auditLogService = AuditLogService();

  List<dynamic> auditLogs = [];
  bool isLoading = false;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;

  AuditLogController() {
    print("✅ AuditLogController diinisialisasi, memanggil fetchAuditLogs...");
    fetchAuditLogs();
  }

  Future<void> fetchAuditLogs({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      auditLogs = [];
      isLoading = true;
    } else {
      if (currentPage >= totalPages) {
        print("ℹ️ Sudah di halaman terakhir. Tidak memuat lebih banyak.");
        return;
      }
      currentPage++;
    }

    errorMessage = null;
    notifyListeners();
    print("🚀 Memulai fetch data audit log untuk halaman: $currentPage...");

    try {
      final result = await _auditLogService.getAuditLogs(page: currentPage);
      
      // -- DEBUGGING PRINT --
      // Cetak seluruh respons dari server untuk melihat strukturnya.
      print("✅ DATA DITERIMA DARI SERVER:");
      // Menggunakan jsonEncode dengan indentasi agar mudah dibaca.
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(result);
      print(prettyprint);
      // --------------------

      auditLogs.addAll(result['data']);
      totalPages = result['pagination']['totalPages'];
      
      print("👍 Berhasil fetch. Jumlah log sekarang: ${auditLogs.length}. Total halaman: $totalPages.");

    } catch (e) {
      // -- DEBUGGING PRINT --
      // Cetak error jika terjadi kesalahan.
      print("❌ TERJADI ERROR saat fetch data:");
      print(e.toString());
      // --------------------
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Helper untuk memformat pesan log agar mudah dibaca
  String formatLogMessage(Map<String, dynamic> log) {
    final userName = log['user']?['nama'] ?? 'User tidak dikenal';
    final action = log['action'];
    final changes = log['changes'];

    final beforeQty = changes['before']?['quantity'];
    final afterQty = changes['after']?['quantity'];
    final details = changes['details'] ?? 'stok produk';

    switch (action) {
      case 'CREATE':
        return '$userName menambahkan $details. Stok baru: $afterQty.';
      case 'UPDATE':
        return '$userName memperbarui $details dari $beforeQty menjadi $afterQty.';
      case 'DELETE':
        return '$userName menghapus $details. Stok sebelumnya: $beforeQty.';
      default:
        return 'Aksi tidak dikenal oleh $userName.';
    }
  }

  // Helper untuk format tanggal
  String formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return isoString;
    }
  }
}