import 'package:workorderapp/entity/user.dart';

class Comment {
  final int id;
  final int workOrderId;
  final String comment;
  final User user;
  final DateTime? createdAt;

  Comment({
    required this.id,
    required this.workOrderId,
    required this.comment,
    required this.user,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: (json['id'] as num).toInt(),
      workOrderId: (json['work_order_id'] as num).toInt(),
      comment: json['comment'] ?? '',
      user:
          json['user'] !=
              null // ← add null check
          ? User.fromJson(json['user'])
          : User(
              id: 0,
              name: 'Unknown',
              username: '',
              roles: [],
              department: null,
            ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
