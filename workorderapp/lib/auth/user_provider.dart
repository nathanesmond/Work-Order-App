import 'package:flutter/material.dart';
import '../client/api_user.dart';
import '../entity/user.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;

  List<User> users = [];
  User? currentUser;

  String searchQuery = '';
  int? departmentFilter;

  Future<void> fetchUsers({String? search, int? departmentId}) async {
    isLoading = true;
    notifyListeners();

    final data = await ApiUser.fetchUsers(
      search: search ?? searchQuery,
      departmentId: departmentId ?? departmentFilter,
    );

    users = (data ?? []).map((j) => User.fromJson(j)).toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserDetails() async {
    isLoading = true;
    notifyListeners();

    final data = await ApiUser.fetchUserProfile();
    currentUser = data != null ? User.fromJson(data) : null;

    isLoading = false;
    notifyListeners();
  }

  Future<void> createUser({
    required String name,
    required String username,
    required String password,
    required String role,
    required int departmentid,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final apiUser = ApiUser();
      final json = await apiUser.createUser(
        name: name,
        username: username,
        password: password,
        role: role,
        departmentid: departmentid,
      );
      if (json != null) users.insert(0, User.fromJson(json));
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser({
    required int id,
    required String name,
    required String username,
    required String role,
    int? departmentid,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final apiUser = ApiUser();
      final json = await apiUser.updateUser(
        id: id,
        name: name,
        username: username,
        role: role,
        departmentid: departmentid,
      );
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1 && json != null) users[index] = User.fromJson(json);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await ApiUser.deleteUser(id);
      users.removeWhere((u) => u.id == id);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
