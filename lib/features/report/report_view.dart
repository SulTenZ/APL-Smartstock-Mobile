import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'report_controller.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportController(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Laporan Keuangan"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Consumer<ReportController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                _buildDatePicker(context, controller),
                Expanded(
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : controller.errorMessage != null
                          ? Center(child: Text(controller.errorMessage!))
                          : controller.summaryData == null
                              ? const Center(child: Text("Tidak ada data untuk periode ini."))
                              : _buildReportBody(controller),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<ReportController>(
          builder: (context, controller, child) {
            return FloatingActionButton(
              onPressed: controller.summaryData != null ? controller.downloadPdf : null,
              backgroundColor: controller.summaryData != null ? Colors.red[400] : Colors.grey,
              tooltip: 'Download PDF',
              child: const Icon(Icons.picture_as_pdf, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, ReportController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Periode Laporan:", style: TextStyle(fontSize: 16)),
          TextButton(
            onPressed: () => controller.selectDate(context),
            child: Row(
              children: [
                Text(
                  DateFormat.yMMMM('id_ID').format(controller.selectedDate),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_month_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportBody(ReportController controller) {
    final data = controller.summaryData!;
    return RefreshIndicator(
      onRefresh: controller.fetchReport,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildReportCard(
            icon: Icons.attach_money,
            iconColor: Colors.green,
            title: 'Total Pendapatan (Omzet)',
            value: controller.formatCurrency(data['totalRevenue']),
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            icon: Icons.trending_up,
            iconColor: Colors.blue,
            title: 'Total Keuntungan (Profit)',
            value: controller.formatCurrency(data['totalProfit']),
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            icon: Icons.receipt_long,
            iconColor: Colors.orange,
            title: 'Jumlah Transaksi',
            value: '${data['transactionCount']} Transaksi',
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.1),
              radius: 24,
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}