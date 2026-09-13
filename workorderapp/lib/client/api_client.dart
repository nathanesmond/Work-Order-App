import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static final storage = FlutterSecureStorage();
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('username: "$username"');
    print('STATUS: ${response.statusCode}');
    print(response.body);

    return jsonDecode(response.body);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  static Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  static Future<Map<String, dynamic>?> fetchMe() async {
    final token = await getToken();

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
}
