import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth/notification_provider.dart';
import '../entity/notification.dart';

void showNotificationSheet(BuildContext context) {
  context.read<NotificationProvider>().fetchNotifications();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _NotificationSheet(),
  );
}

class _NotificationSheet extends StatelessWidget {
  const _NotificationSheet();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBFE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 12, 8),
              child: Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  if (provider.unreadCount > 0)
                    TextButton(
                      onPressed: () =>
                          context.read<NotificationProvider>().markAllRead(),
                      child: const Text(
                        'Mark all read',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade200, height: 1),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : provider.notifications.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: provider.notifications.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade100, height: 1),
                      itemBuilder: (_, i) => _NotificationTile(
                        notification: provider.notifications[i],
                        onTap: () => context
                            .read<NotificationProvider>()
                            .markRead(provider.notifications[i].id),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread ? Colors.red.withOpacity(.04) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.createdAt != null
                        ? DateFormat(
                            'dd MMM yyyy • HH:mm',
                          ).format(notification.createdAt!.toLocal())
                        : '',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
