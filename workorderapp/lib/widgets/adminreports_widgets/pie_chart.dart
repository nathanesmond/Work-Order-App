import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPieChart extends StatelessWidget {
  final Map<String, int> counts;

  const ReportPieChart({super.key, required this.counts});

  Color _colorFor(String status) {
    switch (status) {
      case "on_request":
        return Colors.orange;
      case "in_progress":
        return Colors.purple;
      case "on_hold":
        return Colors.blue;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.grey;
      case "overdue":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  PieChartSectionData _buildSection(int value, Color color) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: value.toString(),
      radius: 85,
      titleStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _buildLegendRows(
    List<MapEntry<String, int>> entries,
    int total,
  ) {
    final rows = <Widget>[];

    for (int i = 0; i < entries.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _LegendItem(
                color: _colorFor(entries[i].key), // ← now accessible
                label: entries[i].key.replaceAll('_', ' '),
                count: entries[i].value,
                percent: (entries[i].value / total * 100).toStringAsFixed(1),
              ),
            ),
            if (i + 1 < entries.length)
              Expanded(
                child: _LegendItem(
                  color: _colorFor(entries[i + 1].key),
                  label: entries[i + 1].key.replaceAll('_', ' '),
                  count: entries[i + 1].value,
                  percent: (entries[i + 1].value / total * 100).toStringAsFixed(
                    1,
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      rows.add(const SizedBox(height: 10));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);

    if (total == 0) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: Text(
            "No data for this range",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 36,
              sections: counts.entries
                  .where((e) => e.value > 0)
                  .map((e) => _buildSection(e.value, _colorFor(e.key)))
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildLegendRows(
                counts.entries.where((e) => e.value > 0).toList(),
                total,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final String percent;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.count,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            '$label: $count ($percent%)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
