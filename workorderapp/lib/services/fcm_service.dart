import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../client/api_client.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.notification?.title}');
}

class FcmService {
  static final _messaging = FirebaseMessaging.instance;
  static const _baseUrl = 'http://192.168.99.7:8000/api';

  static Future<void> init() async {
    print('FcmService.init called');

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('FCM permission denied');
      return;
    }

    final token = await _messaging.getToken();
    print('FCM Token: $token');
    if (token != null) await _sendTokenToBackend(token);

    _messaging.onTokenRefresh.listen(_sendTokenToBackend);

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground FCM received: ${message.notification?.title}');
      print('Foreground FCM body: ${message.notification?.body}');
    });
  }

  static Future<void> _sendTokenToBackend(String fcmToken) async {
    final authToken = await ApiClient.getToken();
    if (authToken == null) return;

    final response = await http.post(
      Uri.parse('$_baseUrl/fcm-token'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    print('FCM token sent: ${response.statusCode}');
  }

  static void _showBanner(BuildContext context, RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              notification.body ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
