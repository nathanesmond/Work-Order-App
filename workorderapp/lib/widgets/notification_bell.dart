import 'package:flutter/material.dart';
import 'package:workorderapp/entity/user.dart';
import 'package:workorderapp/widgets/notification_sheet.dart';

bool canSeeNotifications(User? user) {
  if (user == null) return false;
  const allowedDepts = [1, 10, 11];
  if (allowedDepts.contains(user.department?.id)) return true;
  if (user.roles.contains('admin') ||
      user.roles.contains('superadmin') ||
      user.roles.contains('requester'))
    return true;
  return false;
}

Widget notificationBell(BuildContext context, int unreadCount) {
  return Padding(
    padding: const EdgeInsets.only(right: 4),
    child: Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => showNotificationSheet(context),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
