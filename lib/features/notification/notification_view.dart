// lib/features/notification/notification_view.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'notification_controller.dart';
import '../../common/color/color_theme.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationController(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifikasi'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Consumer<NotificationController>(
              builder: (context, controller, child) {
                if (controller.isLoading || controller.unreadCount == 0) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    onPressed: () => controller.markAllAsRead(),
                    child: const Text('Baca semua'),
                  ),
                );
              },
            ),
          ],
        ),
        body: Consumer<NotificationController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Error: ${controller.errorMessage}'),
                ),
              );
            }

            if (controller.notifications.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Tidak ada notifikasi',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchNotifications(showLoading: false),
              child: ListView.separated(
                itemCount: controller.notifications.length,
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final notif = controller.notifications[index];
                  final bool isRead = notif['isRead'];
                  final DateTime createdAt = DateTime.parse(notif['createdAt']);

                  return InkWell(
                    onTap: () {
                      controller.markAsRead(notif['id'], index);
                      if (notif['product'] != null && notif['product']['id'] != null) {
                        Navigator.pushNamed(context, '/product/detail', arguments: {'id': notif['product']['id']});
                      }
                    },
                    child: Container(
                      color: isRead ? Colors.transparent : const Color(ColorTheme.primaryColor).withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _getIconForType(notif['type']),
                            color: isRead ? Colors.grey.shade600 : const Color(ColorTheme.primaryColor),
                            size: 28,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notif['heading'],
                                  style: TextStyle(
                                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif['content'],
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(createdAt.toLocal()),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'LOW_STOCK':
        return Icons.warning_amber_rounded;
      case 'OUT_OF_STOCK':
        return Icons.error_outline_rounded;
      case 'PROMO':
        return Icons.campaign_rounded;
      default:
        return Icons.notifications;
    }
  }
}