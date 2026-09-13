import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/user_provider.dart';
import 'package:workorderapp/screens/admin/admin_calendar.dart';
import 'package:workorderapp/widgets/notification_bell.dart';
import '../../auth/auth_provider.dart';
import '../../auth/notification_provider.dart';
import 'admin_home.dart';
import 'admin_users.dart';
import 'admin_reports.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _index = 2;

  final pages = const [
    AdminHome(),
    AdminUsers(),
    AdminCalendar(),
    AdminReports(),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationProvider>().fetchNotifications();
      context.read<UserProvider>().fetchUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final unreadCount = context.watch<NotificationProvider>().unreadCount;
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name ?? 'Admin'}'),
        actions: [
          if (canSeeNotifications(context.read<UserProvider>().currentUser))
            notificationBell(context, unreadCount),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await auth.logout(),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color.fromRGBO(159, 125, 76, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
