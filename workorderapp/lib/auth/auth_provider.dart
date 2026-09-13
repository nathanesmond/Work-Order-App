import 'package:flutter/material.dart';
import '../client/api_client.dart';
import '../services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthenticated = false;
  String? role;

  String? _extractRole(List roles) {
    if (roles.isEmpty) return null;

    final first = roles.first;

    if (first is String) return first;

    if (first is Map && first['name'] != null) return first['name'];

    return null;
  }

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    final response = await ApiClient.login(username, password);
    isLoading = false;

    if (response['token'] != null) {
      await ApiClient.saveToken(response['token']);
      final roles = response['user']['roles'] as List;
      role = _extractRole(roles);
      isAuthenticated = true;
      notifyListeners();
      FcmService.init();
      return true;
    }

    notifyListeners();
    return false;
  }

  Future<void> tryAutoLogin() async {
    final userData = await ApiClient.fetchMe();
    if (userData == null) return;
    final roles = userData['roles'] as List;
    role = _extractRole(roles);
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await ApiClient.logout();
    isAuthenticated = false;
    role = null;
    notifyListeners();
  }
}
