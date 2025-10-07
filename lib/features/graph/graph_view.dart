// lib/features/graph/graph_view.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/custom_drop_down.dart';
import '../../common/widgets/custom_graph.dart';
import '../../data/services/graph_service.dart';
import 'graph_controller.dart';

class GraphView extends StatelessWidget {
  const GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GraphController(GraphService()),
      child: const _GraphPage(),
    );
  }
}

class _GraphPage extends StatefulWidget {
  const _GraphPage();

  @override
  State<_GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<_GraphPage> {
  final _startCtrl = TextEditingController();
  final _endCtrl = TextEditingController();

  @override
  void dispose() {
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GraphController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  const Text(
                    'GRAFIK PROFIT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Consumer<GraphController>(
                builder: (context, c, _) {
                  _startCtrl.text = c.startDate;
                  _endCtrl.text = c.endDate;
                  
                  return _FilterBar(
                    startCtrl: _startCtrl,
                    endCtrl: _endCtrl,
                    bucket: c.bucket,
                    onBucketChanged: (b) => controller.setBucket(b),
                    onDateChanged: (start, end) =>
                        controller.setDateRange(start: start, end: end),
                  );
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Consumer<GraphController>(
                  builder: (context, c, _) {
                    if (c.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (c.errorMessage != null) {
                      return Center(
                        child: Text(
                          c.errorMessage!,
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    }

                    return ListView(
                      children: [
                        // Grafik paling atas
                        _SectionCard(
                          title: 'Tren Profit (${_bucketLabel(c.bucket)})',
                          child: CustomGraph(
                            xLabels: c.currentSeries.keys.toList(),
                            
                            values: c.currentSeries.values
                                .map((e) => e.toDouble())
                                .toList(),
                                
                            showYAxis: true,
                            yTicks: 3,
                            yLabelFormatter: (v) => 'Rp ${v.toStringAsFixed(0)}',
                            lineColor: const Color(0xFF4E73DF),
                            gradientArea: const [
                              Color(0xFF4E73DF),
                              Color(0xFF2ECC71),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        _SummaryColumn(
                          revenue: c.totalRevenue,
                          cost: c.totalCost,
                          profit: c.totalProfit,
                        ),

                        const SizedBox(height: 20),

                        _SectionCard(
                          title: 'Top 5 Produk (Profit)',
                          child: _TopProductsList(items: c.topProducts),
                        ),
                        const SizedBox(height: 20),
                        _SectionCard(
                          title: 'Performa Brand',
                          child: _BrandPerformanceList(items: c.brandPerformance),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _bucketLabel(ProfitBucket b) {
    switch (b) {
      case ProfitBucket.day:
        return 'Harian';
      case ProfitBucket.week:
        return 'Mingguan';
      case ProfitBucket.month:
        return 'Bulanan';
      case ProfitBucket.year:
        return 'Tahunan';
      case ProfitBucket.custom:
        return 'Custom';
    }
  }
}

class _FilterBar extends StatelessWidget {
  final TextEditingController startCtrl;
  final TextEditingController endCtrl;
  final ProfitBucket bucket;
  final ValueChanged<ProfitBucket> onBucketChanged;
  final void Function(String start, String end) onDateChanged;

  const _FilterBar({
    required this.startCtrl,
    required this.endCtrl,
    required this.bucket,
    required this.onBucketChanged,
    required this.onDateChanged,
  });

  Future<void> _pickDate(BuildContext context, TextEditingController ctrl) async {
    final initial = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Pilih Tanggal (YYYY-MM-DD)',
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      ctrl.text = '$y-$m-$d';
      onDateChanged(startCtrl.text.trim(), endCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final showCustomDates = bucket == ProfitBucket.custom;

    return Column(
      children: [
        // Periode
        Row(
          children: [
            Expanded(
              child: CustomDropDown<ProfitBucket>(
                label: 'Periode',
                hintText: 'Pilih periode',
                value: bucket,
                items: const [
                  DropdownMenuItem(value: ProfitBucket.day, child: Text('Harian')),
                  DropdownMenuItem(value: ProfitBucket.week, child: Text('Mingguan')),
                  DropdownMenuItem(value: ProfitBucket.month, child: Text('Bulanan')),
                  DropdownMenuItem(value: ProfitBucket.year, child: Text('Tahunan')),
                  DropdownMenuItem(value: ProfitBucket.custom, child: Text('Custom')),
                ],
                onChanged: (v) {
                  if (v != null) onBucketChanged(v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (showCustomDates)
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'Start Date',
                  controller: startCtrl,
                  onTap: () => _pickDate(context, startCtrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DateField(
                  label: 'End Date',
                  controller: endCtrl,
                  onTap: () => _pickDate(context, endCtrl),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C2C2C),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                prefixIcon:
                    const Icon(Icons.date_range, color: Color(0xFF9E9E9E)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                border: border,
                enabledBorder: border,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF757575),
                    width: 1.5,
                  ),
                ),
              ),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  final num revenue;
  final num cost;
  final num profit;

  const _SummaryColumn({
    required this.revenue,
    required this.cost,
    required this.profit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryCard(title: 'Total Revenue', value: revenue),
        const SizedBox(height: 12),
        _SummaryCard(title: 'Total Cost', value: cost),
        const SizedBox(height: 12),
        _SummaryCard(title: 'Total Profit', value: profit),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final num value;

  const _SummaryCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final currency = 'Rp ${value.toStringAsFixed(0)}';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF7A7A7A))),
          const SizedBox(height: 8),
          Text(currency,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TopProductsList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _TopProductsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Belum ada data.',
          style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A)),
        ),
      );
    }

    return Column(
      children: items.map((e) {
        final name = (e['productName'] ?? '-') as String;
        final brand = (e['brandName'] ?? '-') as String;
        final profit = (e['profit'] ?? 0);
        final profitStr =
            (profit is num) ? profit.toStringAsFixed(0) : profit.toString();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$name • $brand',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                Text(
                  'Rp $profitStr',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BrandPerformanceList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _BrandPerformanceList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Belum ada data.',
          style: GoogleFonts.poppins(color: const Color(0xFF7A7A7A)),
        ),
      );
    }

    return Column(
      children: items.map((e) {
        final brand = (e['brand'] ?? '-') as String;
        final profit = (e['profit'] ?? 0);
        final margin = (e['profitMargin'] ?? 0);

        final profitStr =
            (profit is num) ? profit.toStringAsFixed(0) : profit.toString();
        final marginStr =
            (margin is num) ? margin.toStringAsFixed(1) : margin.toString();

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    brand,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
                Text(
                  'Rp $profitStr • $marginStr%',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}