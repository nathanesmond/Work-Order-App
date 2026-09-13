import 'package:workorderapp/entity/comment.dart';
import 'package:workorderapp/entity/department.dart';
import 'package:workorderapp/entity/user.dart';

class WorkOrder {
  final int id;

  final String title;
  final String description;
  final String status;

  final int requesterId;
  final int? assignedEngineerId;
  final int? departmentId;
  final int? priorityId;

  final DateTime? dueAt;
  final DateTime? assignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? overdueAt;
  final DateTime? cancelledAt;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? cancelledBy;
  final String? cancelledRole;

  final User requester;
  final User? engineer;
  final Department? department;
  final User? cancelledByUser;
  final List<Comment> comments;
  WorkOrder({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.requesterId,
    required this.requester,
    this.assignedEngineerId,
    this.departmentId,
    this.priorityId,
    this.engineer,
    this.department,
    this.cancelledByUser,
    this.dueAt,
    this.assignedAt,
    this.startedAt,
    this.completedAt,
    this.overdueAt,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
    this.cancelledBy,
    this.cancelledRole,
    this.comments = const [],
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    try {
      int? parseNullableInt(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is String && value.isNotEmpty) return int.tryParse(value);
        return null;
      }

      DateTime? parseNullableDateTime(dynamic value) {
        if (value == null) return null;
        try {
          return DateTime.parse(value.toString()).toLocal();
        } catch (_) {
          return null;
        }
      }

      return WorkOrder(
        id: parseNullableInt(json['id']) ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        status: json['status'] ?? '',
        requesterId: parseNullableInt(json['requester_id']) ?? 0,
        assignedEngineerId: parseNullableInt(json['assigned_engineer_id']),
        departmentId: parseNullableInt(json['department_id']),
        priorityId: parseNullableInt(json['priority_id']),
        requester: json['requester'] != null
            ? User.fromJson(json['requester'])
            : User(
                id: 0,
                name: 'Unknown',
                username: 'unknown@example.com',
                roles: [],
                department: null,
              ),
        engineer: json['engineer'] != null
            ? User.fromJson(json['engineer'])
            : null,
        department: json['department'] != null
            ? Department.fromJson(json['department'])
            : null,
        cancelledByUser: json['cancelled_by_user'] != null
            ? User.fromJson(json['cancelled_by_user'])
            : null,
        comments: (json['comments'] as List? ?? [])
            .map((c) => Comment.fromJson(c))
            .toList(),
        dueAt: parseNullableDateTime(json['due_at']),
        assignedAt: parseNullableDateTime(json['assigned_at']),
        startedAt: parseNullableDateTime(json['started_at']),
        completedAt: parseNullableDateTime(json['completed_at']),
        overdueAt: parseNullableDateTime(json['overdue_at']),
        cancelledAt: parseNullableDateTime(json['cancelled_at']),
        createdAt: parseNullableDateTime(json['created_at']),
        updatedAt: parseNullableDateTime(json['updated_at']),
        cancelledBy: parseNullableInt(json['cancelled_by']),
        cancelledRole: json['cancelled_role'],
      );
    } catch (e) {
      rethrow;
    }
  }
}
