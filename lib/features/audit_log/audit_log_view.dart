// lib/features/audit_log/audit_log_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audit_log_controller.dart';

class AuditLogView extends StatelessWidget {
  const AuditLogView({super.key});

  @override
  Widget build(BuildContext context) {
    // [OPTIMASI]: Provider hanya membungkus bagian yang membutuhkan data (Body)
    return ChangeNotifierProvider(
      create: (_) => AuditLogController()..fetchAuditLogs(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header statis
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
                      'RIWAYAT STOK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF222222),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Body dinamis yang akan di-rebuild
                const Expanded(
                  child: _AuditLogList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuditLogList extends StatelessWidget {
  const _AuditLogList();

  @override
  Widget build(BuildContext context) {
    // [OPTIMASI]: Consumer hanya membungkus list yang dinamis
    return Consumer<AuditLogController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null) {
          return Center(
              child: Text('Error: ${controller.errorMessage}'));
        }

        if (controller.auditLogs.isEmpty) {
          return const Center(
              child: Text('Tidak ada riwayat perubahan stok.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: controller.auditLogs.length,
          itemBuilder: (context, index) {
            final log = controller.auditLogs[index];
            return _AuditLogCard(log: log, controller: controller);
          },
        );
      },
    );
  }
}

class _AuditLogCard extends StatelessWidget {
  final Map<String, dynamic> log;
  final AuditLogController controller;

  const _AuditLogCard({required this.log, required this.controller});

  IconData get _icon {
    switch (log['action']) {
      case 'CREATE':
        return Icons.add_circle_outline;
      case 'UPDATE':
        return Icons.edit_note;
      case 'DELETE':
        return Icons.remove_circle_outline;
      default:
        return Icons.history;
    }
  }

  Color get _iconColor {
    switch (log['action']) {
      case 'CREATE':
        return Colors.green;
      case 'UPDATE':
        return Colors.blue;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: _iconColor.withOpacity(0.1),
            child: Icon(_icon, color: _iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.formatLogMessage(log),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.formatDateTime(log['createdAt']),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}