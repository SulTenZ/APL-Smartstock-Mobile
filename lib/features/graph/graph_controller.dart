import 'package:flutter/material.dart';
import '../../data/services/graph_service.dart';

enum ProfitBucket { day, week, month, year, custom }

class GraphController extends ChangeNotifier {
  final GraphService _service;

  GraphController(this._service) {
    fetch();
  }

  // state
  bool _loading = false;
  String? _error;
  ProfitBucket _bucket = ProfitBucket.day;

  String _start = '';
  String _end = '';

  Map<String, num> _series = {};
  num _totalRevenue = 0;
  num _totalCost = 0;
  num _totalProfit = 0;
  List<Map<String, dynamic>> _topProducts = [];
  List<Map<String, dynamic>> _brandPerf = [];

  // getters
  bool get isLoading => _loading;
  String? get errorMessage => _error;
  ProfitBucket get bucket => _bucket;

  String get startDate => _start;
  String get endDate => _end;

  Map<String, num> get currentSeries => _series;
  num get totalRevenue => _totalRevenue;
  num get totalCost => _totalCost;
  num get totalProfit => _totalProfit;
  List<Map<String, dynamic>> get topProducts => _topProducts;
  List<Map<String, dynamic>> get brandPerformance => _brandPerf;

  // actions
  void setBucket(ProfitBucket b) {
    _bucket = b;
    if (b != ProfitBucket.custom) {
      // reset tanggal jika bukan custom
      _start = '';
      _end = '';
      fetch();
    } else {
      // custom → tunggu user pilih tanggal; tidak langsung fetch
      notifyListeners();
    }
  }

  void setDateRange({required String start, required String end}) {
    _start = start;
    _end = end;
    // kalau bucket custom dan dua2nya terisi → fetch
    if (_bucket == ProfitBucket.custom && _start.isNotEmpty && _end.isNotEmpty) {
      fetch();
    } else {
      notifyListeners();
    }
  }

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final isCustom = _bucket == ProfitBucket.custom;
      final data = await _service.getProfitReport(
        startDate: isCustom && _start.isNotEmpty ? _start : null,
        endDate: isCustom && _end.isNotEmpty ? _end : null,
      );

      _totalRevenue = (data['summary']?['totalRevenue'] ?? 0) as num;
      _totalCost = (data['summary']?['totalCost'] ?? 0) as num;
      _totalProfit = (data['summary']?['totalProfit'] ?? 0) as num;

      final byDay = Map<String, num>.from(
          (data['profitByDay'] ?? const <String, dynamic>{}) as Map);
      final byWeek = Map<String, num>.from(
          (data['profitByWeek'] ?? const <String, dynamic>{}) as Map);
      final byMonth = Map<String, num>.from(
          (data['profitByMonth'] ?? const <String, dynamic>{}) as Map);
      final byYear = Map<String, num>.from(
          (data['profitByYear'] ?? const <String, dynamic>{}) as Map);

      switch (_bucket) {
        case ProfitBucket.day:
          _series = byDay;
          break;
        case ProfitBucket.week:
          _series = byWeek;
          break;
        case ProfitBucket.month:
          _series = byMonth;
          break;
        case ProfitBucket.year:
          _series = byYear;
          break;
        case ProfitBucket.custom:
          // default gunakan harian saat custom agar lebih detail
          _series = byDay;
          break;
      }

      _topProducts = List<Map<String, dynamic>>.from(data['topProducts'] ?? []);
      _brandPerf = List<Map<String, dynamic>>.from(data['brandPerformance'] ?? []);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
