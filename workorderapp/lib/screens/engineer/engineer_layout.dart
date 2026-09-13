import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/user_provider.dart';
import 'package:workorderapp/screens/engineer/engineer_profile.dart';
import 'package:workorderapp/screens/engineer/engineer_task.dart';
import 'package:workorderapp/widgets/notification_bell.dart';
import '../../auth/auth_provider.dart';
import '../../auth/notification_provider.dart';
import 'engineer_home.dart';

class EngineerLayout extends StatefulWidget {
  const EngineerLayout({super.key});

  @override
  State<EngineerLayout> createState() => _EngineerLayoutState();
}

class _EngineerLayoutState extends State<EngineerLayout> {
  int _index = 0;

  final pages = const [EngineerHome(), EngineerTask(), EngineerProfile()];

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
        title: Text('Welcome, ${user?.name ?? 'Engineer'}'),
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
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color.fromRGBO(159, 125, 76, 1),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Jobs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
