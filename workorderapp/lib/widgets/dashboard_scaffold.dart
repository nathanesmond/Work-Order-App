import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../auth/notification_provider.dart';
import '../widgets/notification_sheet.dart';

class DashboardScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends State<DashboardScaffold> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NotificationProvider>().fetchNotifications(),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthProvider>();
    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
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
          ),
        ],
      ),
      body: widget.body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        items: widget.items,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
