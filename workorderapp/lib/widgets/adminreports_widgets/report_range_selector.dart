import 'package:flutter/material.dart';

enum ReportRange { all, days30, weeks2, week1, day1 }

class ReportRangeSelector extends StatelessWidget {
  final ReportRange selected;
  final Function(ReportRange) onChanged;

  const ReportRangeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ReportRange>(
      value: selected,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      items: const [
        DropdownMenuItem(value: ReportRange.all, child: Text("All Time")),
        DropdownMenuItem(
          value: ReportRange.days30,
          child: Text("Last 30 Days"),
        ),
        DropdownMenuItem(
          value: ReportRange.weeks2,
          child: Text("Last 2 Weeks"),
        ),
        DropdownMenuItem(value: ReportRange.week1, child: Text("Last 7 Days")),
        DropdownMenuItem(value: ReportRange.day1, child: Text("Last 24 Hours")),
      ],
    );
  }
}
