import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ApiUser {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<dynamic>?> fetchUsers({
    String? search,
    int? departmentId,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final query = {
      if (search != null && search.isNotEmpty) "search": search,
      if (departmentId != null) "department_id": departmentId.toString(),
    };

    final response = await http.get(
      Uri.parse('$baseUrl/users').replace(queryParameters: query),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    final token = await ApiClient.getToken();
    if (token == null) return null;
    final response = await http.get(
      Uri.parse('$baseUrl/showUser'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<Map<String, dynamic>?> createUser({
    required String name,
    required String username,
    required String password,
    required String role,
    required int departmentid,
  }) async {
    final token = await ApiClient.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/createUser'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'username': username,
        'password': password,
        'role': role,
        'department_id': departmentid,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    final body = jsonDecode(response.body);
    throw Exception(body['message'] ?? 'Failed to create user');
  }

  Future<Map<String, dynamic>?> updateUser({
    required int id,
    String? name,
    String? username,
    String? password,
    String? role,
    int? departmentid,
  }) async {
    final token = await ApiClient.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/updateUser/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (name != null) 'name': name,
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        if (role != null) 'role': role,
        if (departmentid != null) 'department_id': departmentid,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to update user : ${response.body}');
  }

  static Future<bool> deleteUser(int id) async {
    final token = await ApiClient.getToken();

    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/deleteUser/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed');
    }
    return response.statusCode == 200;
  }
}
