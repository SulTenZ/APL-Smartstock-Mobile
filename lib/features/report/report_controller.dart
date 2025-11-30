import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/services/report_service.dart';

class ReportController with ChangeNotifier {
  final ReportService _reportService = ReportService();

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  Map<String, dynamic>? summaryData;
  bool isLoading = false;
  String? errorMessage;

  ReportController() {
    fetchReport();
  }

  Future<void> fetchReport() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summaryData = await _reportService.getFinancialSummary(
        year: _selectedDate.year,
        month: _selectedDate.month,
      );
    } catch (e) {
      errorMessage = e.toString();
      summaryData = null;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final newDate = await showMonthYearPicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id'),
    );

    if (newDate != null) {
      _selectedDate = newDate;
      fetchReport();
    }
  }

  // --- BAGIAN YANG DIPERBAIKI ---
  Future<void> downloadPdf() async {
    try {
      // Kita gunakan 'await' karena method di service sekarang mengembalikan Future<String>
      // Ini akan menyelesaikan error "Future<String> can't be assigned to String"
      final urlString = await _reportService.getFinancialSummaryPdfUrl(
        year: _selectedDate.year,
        month: _selectedDate.month,
      );

      final uri = Uri.parse(urlString);

      if (await canLaunchUrl(uri)) {
        // Mode externalApplication penting agar browser/PDF viewer default yang menangani
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        errorMessage = 'Tidak dapat membuka link download';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Gagal menyiapkan link download: $e';
      notifyListeners();
    }
  }

  String formatCurrency(dynamic value) {
    final number = value is num ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }
}
