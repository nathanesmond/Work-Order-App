import 'package:flutter/material.dart';
import '../client/api_notification.dart';
import '../entity/notification.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> notifications = [];
  int unreadCount = 0;
  bool isLoading = false;

  Future<void> fetchNotifications() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiNotification.fetchNotifications();
    notifications = (data ?? [])
        .map((j) => AppNotification.fromJson(j))
        .toList();
    unreadCount = notifications.where((n) => !n.isRead).length;

    isLoading = false;
    notifyListeners();
  }

  Future<void> markRead(int id) async {
    await ApiNotification.markRead(id);
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = AppNotification(
        id: notifications[index].id,
        workOrderId: notifications[index].workOrderId,
        title: notifications[index].title,
        message: notifications[index].message,
        isRead: true,
        createdAt: notifications[index].createdAt,
      );
      unreadCount = notifications.where((n) => !n.isRead).length;
      notifyListeners();
    }
  }

  Future<void> markAllRead() async {
    await ApiNotification.markAllRead();
    notifications = notifications
        .map(
          (n) => AppNotification(
            id: n.id,
            workOrderId: n.workOrderId,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
          ),
        )
        .toList();
    unreadCount = 0;
    notifyListeners();
  }
}
