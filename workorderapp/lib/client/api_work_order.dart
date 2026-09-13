import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workorderapp/client/api_client.dart';

class ApiWorkOrder {
  static const baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<dynamic>?> fetchWorkOrders({
    String? search,
    String? status,
    String? range,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final query = {
      if (search != null && search.isNotEmpty) "search": search,
      if (status != null && status.isNotEmpty && status != 'all')
        "status": status,
      if (range != null && range.isNotEmpty && range != 'all') "range": range,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/viewAllWorkOrders').replace(queryParameters: query),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        print('Body length: ${response.body.length}');
        return null;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchPaginated({
    int page = 1,
    int perPage = 10,
    String sortBy = "created_at",
    String sortDir = "desc",
    String search = "",
    String? range,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) throw Exception("No token found");

    final query = {
      "page": page.toString(),
      "per_page": perPage.toString(),
      "sort_by": sortBy,
      "sort_dir": sortDir,
      "search": search,
      if (range != null && range.isNotEmpty) "range": range,
    };

    final uri = Uri.parse(
      "$baseUrl/paginateWorkOrders",
    ).replace(queryParameters: query);

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print("URL: $uri");
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load work orders");
    }
  }

  static Future<List<dynamic>?> fetchAvailableWorkOrders({
    String? search,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final query = {if (search != null && search.isNotEmpty) "search": search};

    final response = await http.get(
      Uri.parse(
        '$baseUrl/availableAssignments',
      ).replace(queryParameters: query),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  static Future<List<dynamic>?> fetchMyWorkOrders() async {
    final token = await ApiClient.getToken();

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/myAssignments'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<List<dynamic>?> fetchMyHistory() async {
    final token = await ApiClient.getToken();
    if (token == null) return null;
    final response = await http.get(
      Uri.parse('$baseUrl/myHistory'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<List<dynamic>?> fetchMyRequests({
    String? search,
    String? status,
    String? range,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final query = {
      if (search != null && search.isNotEmpty) "search": search,
      if (status != null && status.isNotEmpty && status != 'all')
        "status": status,
      if (range != null && range.isNotEmpty && range != 'all') "range": range,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/myWorkOrders').replace(queryParameters: query),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('myRequests status: ${response.statusCode}'); // ← print before if
    print('myRequests body length: ${response.body.length}');
    print('myRequests body: ${response.body}'); // ← print full body

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        return null;
      }
    }

    print('myRequests failed: ${response.statusCode} ${response.body}');
    return null;
  }

  static Future<List<dynamic>?> fetchMyRequestHistory({
    String? search,
    String? status,
    String? range,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final query = {
      if (search != null && search.isNotEmpty) "search": search,
      if (status != null && status.isNotEmpty && status != 'all')
        "status": status,
      if (range != null && range.isNotEmpty && range != 'all') "range": range,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/myWorkOrderHistory').replace(queryParameters: query),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('myRequests status: ${response.statusCode}'); // ← print before if
    print('myRequests body length: ${response.body.length}');
    print('myRequests body: ${response.body}'); // ← print full body

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        return null;
      }
    }

    print('myRequests failed: ${response.statusCode} ${response.body}');
    return null;
  }

  Future<Map<String, dynamic>?> createWorkOrder({
    required String title,
    required String description,
    required int hours,
  }) async {
    final token = await ApiClient.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/createWorkOrder'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'hours': hours,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to create work order: ${response.body}');
  }

  static Future<bool> deleteWorkOrder(int id) async {
    final token = await ApiClient.getToken();

    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/deleteWorkOrder/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Delete failed');
    }
    return response.statusCode == 200;
  }

  static Future<bool> startWorkOrder(int id) async {
    final token = await ApiClient.getToken();

    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/WorkOrder/$id/start'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> completeWorkOrder(int id) async {
    final token = await ApiClient.getToken();

    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/WorkOrder/$id/complete'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> holdWorkOrder(int id, {String? comment}) async {
    final token = await ApiClient.getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/WorkOrder/$id/hold'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> cancelWorkOrder(int id, {String? comment}) async {
    final token = await ApiClient.getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/WorkOrder/$id/cancel'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> resumeWorkOrder(int id) async {
    final token = await ApiClient.getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/WorkOrder/$id/resume'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }
}
