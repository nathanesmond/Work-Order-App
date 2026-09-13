import 'package:flutter/material.dart';

class Meta extends StatelessWidget {
  final IconData icon;
  final String label;

  const Meta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
        ),
      ],
    );
  }
}
