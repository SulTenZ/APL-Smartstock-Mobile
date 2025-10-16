// lib/features/home/home_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/notification_service.dart';

class HomeController extends ChangeNotifier {
  String _userName = '';
  String get userName => _userName;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  final NotificationService _notificationService = NotificationService();

  HomeController() {
    loadData();
  }

  // Metode yang sudah ada
  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Pengguna';
    notifyListeners();
  }

  // Metode baru untuk mengambil data
  Future<void> loadData() async {
    await loadUserName();
    await fetchUnreadCount();
  }
  
  // Metode baru untuk notifikasi
  Future<void> fetchUnreadCount() async {
    try {
      final response = await _notificationService.getNotifications();
      _unreadCount = response['data']['unreadCount'];
    } catch (e) {
      _unreadCount = 0; // Anggap 0 jika ada error
      print("Gagal mengambil unread count: $e");
    }
    notifyListeners();
  }
}