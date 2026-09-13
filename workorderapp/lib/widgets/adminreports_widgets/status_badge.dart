import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "on_request":
        color = Colors.orange;
        break;
      case "in_progress":
        color = Colors.purple;
        break;
      case "on_hold":
        color = Colors.blue;
        break;
      case "completed":
        color = Colors.green;
        break;
      case "cancelled":
        color = Colors.grey;
        break;
      case "overdue":
        color = Colors.red;
        break;
      default:
        color = Colors.black;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status.replaceAll("_", " "),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
