import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ApiNotification {
  static const _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<dynamic>?> fetchNotifications() async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/notifications'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  static Future<int> fetchUnreadCount() async {
    final token = await ApiClient.getToken();
    if (token == null) return 0;

    final response = await http.get(
      Uri.parse('$_baseUrl/notifications/unread-count'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'] ?? 0;
    }
    return 0;
  }

  static Future<void> markRead(int id) async {
    final token = await ApiClient.getToken();
    if (token == null) return;

    await http.put(
      Uri.parse('$_baseUrl/notifications/$id/read'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  static Future<void> markAllRead() async {
    final token = await ApiClient.getToken();
    if (token == null) return;

    await http.put(
      Uri.parse('$_baseUrl/notifications/read-all'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
