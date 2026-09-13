class CalendarOrder {
  final int id;
  final String title;
  final String status;
  final String? department;
  final String? requester;
  final String? engineer;
  final DateTime? createdAt;
  final DateTime? dueAt;
  final DateTime? completedAt;
  final DateTime? overdueAt;

  CalendarOrder({
    required this.id,
    required this.title,
    required this.status,
    this.department,
    this.requester,
    this.engineer,
    this.createdAt,
    this.dueAt,
    this.completedAt,
    this.overdueAt,
  });

  factory CalendarOrder.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) =>
        v != null ? DateTime.tryParse(v.toString()) : null;

    return CalendarOrder(
      id: (json['id'] as num).toInt(),
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      department: json['department'],
      requester: json['requester'],
      engineer: json['engineer'],
      createdAt: parseDate(json['created_at']),
      dueAt: parseDate(json['due_at']),
      completedAt: parseDate(json['completed_at']),
      overdueAt: parseDate(json['overdue_at']),
    );
  }
}
