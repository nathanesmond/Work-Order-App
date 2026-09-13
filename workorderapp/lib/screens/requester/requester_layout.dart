import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_provider.dart';
import '../../auth/user_provider.dart';
import '../../auth/notification_provider.dart';
import '../../widgets/notification_bell.dart';
import 'package:workorderapp/screens/requester/requester_home.dart';
import 'package:workorderapp/screens/requester/requester_requests.dart';
import 'package:workorderapp/screens/requester/requester_profile.dart';

class RequesterLayout extends StatefulWidget {
  const RequesterLayout({super.key});

  @override
  State<RequesterLayout> createState() => _RequesterLayoutState();
}

class _RequesterLayoutState extends State<RequesterLayout> {
  int _index = 1;

  final pages = const [
    RequesterHome(),
    RequesterRequests(),
    RequesterProfile(),
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
    final userProvdier = context.watch<UserProvider>();
    final user = userProvdier.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name ?? 'Requester'}'),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
