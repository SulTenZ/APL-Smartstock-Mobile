// lib/features/notification/notification_controller.dart
import 'package:flutter/material.dart';
import '../../data/services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<dynamic> _notifications = [];
  List<dynamic> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NotificationController() {
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }
    _errorMessage = null;
    
    try {
      final response = await _notificationService.getNotifications();
      if(response['status'] == 'success') {
        _notifications = response['data']['notifications'];
        _unreadCount = response['data']['unreadCount'];
      } else {
         _errorMessage = response['message'] ?? 'Gagal memuat data';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId, int index) async {
    if (!_notifications[index]['isRead']) {
      _notifications[index]['isRead'] = true;
      _unreadCount--;
      notifyListeners();
    }
    await _notificationService.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    for (var notif in _notifications) {
      notif['isRead'] = true;
    }
    _unreadCount = 0;
    notifyListeners();
    await _notificationService.markAllAsRead();
  }
}