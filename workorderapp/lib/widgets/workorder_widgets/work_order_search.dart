import 'package:flutter/material.dart';

class WorkOrderSearch extends StatelessWidget {
  final Function(String) onSearch;

  const WorkOrderSearch({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search work orders...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onChanged: onSearch,
      ),
    );
  }
}
