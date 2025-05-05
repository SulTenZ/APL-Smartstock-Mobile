// lib/utils/currency_formatter.dart
import 'package:intl/intl.dart';

String formatCurrency(dynamic value) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  return formatter.format(value ?? 0);
}
