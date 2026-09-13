class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: (json['id'] as num).toInt(),
      name: json['name'] ?? 'Unknown',
    );
  }
}
