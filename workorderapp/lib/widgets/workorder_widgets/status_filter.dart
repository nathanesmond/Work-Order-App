import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;
  final List<String>? statuses;

  const StatusFilter({
    super.key,
    required this.selected,
    required this.onChanged,
    this.statuses,
  });

  static const _defaultStatuses = [
    'all',
    'on_request',
    'in_progress',
    'on_hold',
    'completed',
    'overdue',
    'cancelled',
  ];
  @override
  Widget build(BuildContext context) {
    final list = statuses ?? _defaultStatuses;

    if (list.length <= 3) {
      return SizedBox(
        height: 42,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: list.map((status) {
              final isSelected = status == selected;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () => onChanged(status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final status = list[i];
          final isSelected = status == selected;

          return GestureDetector(
            onTap: () => onChanged(status),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
