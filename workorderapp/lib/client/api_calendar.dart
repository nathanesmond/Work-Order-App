import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class ApiCalendar {
  static const _baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<dynamic>?> fetchGantt({
    required DateTime start,
    required DateTime end,
  }) async {
    final token = await ApiClient.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$_baseUrl/calendar/gantt').replace(
        queryParameters: {
          'start': start.toIso8601String().substring(0, 10),
          'end': end.toIso8601String().substring(0, 10),
        },
      ),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }
}
