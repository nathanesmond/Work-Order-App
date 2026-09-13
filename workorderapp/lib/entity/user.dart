import 'package:workorderapp/entity/department.dart';

class User {
  final int id;
  final String name;
  final String username;
  final List<String> roles;
  final Department? department;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.roles,

    this.department,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(),
      name: json['name'] ?? 'Unknown',
      username: json['username'] ?? '',
      roles: (json['roles'] as List? ?? [])
          .map((r) => r is Map ? r['name'].toString() : r.toString())
          .toList(),
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
    );
  }
  String get firstRole => roles.isNotEmpty ? roles.first : '';
}
