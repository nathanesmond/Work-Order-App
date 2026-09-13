import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorderapp/entity/work_order.dart';
import '../../auth/work_order_provider.dart';
import 'status_badge.dart';

class ReportTable extends StatelessWidget {
  final List<WorkOrder> orders;
  final WorkOrderProvider provider;

  const ReportTable({super.key, required this.orders, required this.provider});

  String formatDate(DateTime? date) {
    if (date == null) return "-";

    return DateFormat('yyyy-MM-dd HH:mm').format(date.toLocal());
  }

  int? getColumnIndex() {
    switch (provider.sortColumn) {
      case "id":
        return 0;
      case "requester":
        return 1;
      case "title":
        return 2;
      case "status":
        return 3;
      case "created_at":
        return 4;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: getColumnIndex(),
          sortAscending: provider.sortAscending,
          columns: [
            DataColumn(
              label: const Text("ID"),
              onSort: (i, asc) => provider.sort("id", asc),
            ),
            DataColumn(
              label: const Text("Requester"),
              onSort: (i, asc) => provider.sort("requester", asc),
            ),
            DataColumn(
              label: const Text("Title"),
              onSort: (i, asc) => provider.sort("title", asc),
            ),
            DataColumn(
              label: const Text("Status"),
              onSort: (i, asc) => provider.sort("status", asc),
            ),
            DataColumn(
              label: const Text("Created"),
              onSort: (i, asc) => provider.sort("created_at", asc),
            ),
            DataColumn(
              label: const Text("Started"),
              onSort: (i, asc) => provider.sort("started_at", asc),
            ),
            DataColumn(
              label: const Text("Completed"),
              onSort: (i, asc) => provider.sort("completed_at", asc),
            ),
          ],
          rows: orders.map<DataRow>((order) {
            return DataRow(
              cells: [
                DataCell(Text(order.id.toString())),
                DataCell(Text(order.requester.name)),
                DataCell(
                  SizedBox(
                    width: 200,
                    child: Text(order.title, overflow: TextOverflow.ellipsis),
                  ),
                ),
                DataCell(StatusBadge(status: order.status)),
                DataCell(Text(formatDate(order.createdAt))),
                DataCell(Text(formatDate(order.startedAt))),

                DataCell(Text(formatDate(order.completedAt))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
