class AppNotification {
  final int id;
  final int workOrderId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification({
    required this.id,
    required this.workOrderId,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['id'] as num).toInt(),
      workOrderId: (json['work_order_id'] as num).toInt(),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}
