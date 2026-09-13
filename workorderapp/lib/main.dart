import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/calendar_provider.dart';
import 'package:workorderapp/auth/notification_provider.dart';
import 'package:workorderapp/auth/work_order_provider.dart';
import 'package:workorderapp/router.dart';
import 'package:workorderapp/screens/requester/requester_layout.dart';
import 'auth/auth_provider.dart';
import 'auth/user_provider.dart';
import 'client/api_work_order.dart';
import 'firebase_options.dart';
import 'services/fcm_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  runApp(const WorkOrderApp());
}

class WorkOrderApp extends StatelessWidget {
  const WorkOrderApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => WorkOrderProvider(ApiWorkOrder()),
          child: RequesterLayout(),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp.router(
          scaffoldMessengerKey: scaffoldMessengerKey,

          routerConfig: createRouter(context),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
