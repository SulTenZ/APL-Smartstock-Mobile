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

  Future<void> downloadPdf() async {
    // Untuk membuka link download, kita butuh token.
    // Cara paling mudah adalah dengan menambahkan token sebagai query parameter.
    // Mari kita modifikasi sedikit getFinancialSummaryPdfUrl di service.
    // (Untuk sekarang kita asumsikan backend tidak butuh token di URL)

    final urlString = _reportService.getFinancialSummaryPdfUrl(
      year: _selectedDate.year,
      month: _selectedDate.month,
    );
    
    final uri = Uri.parse(urlString);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      errorMessage = 'Tidak dapat membuka link download';
      notifyListeners();
    }
  }

  String formatCurrency(dynamic value) {
    final number = value is num ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(number);
  }
}