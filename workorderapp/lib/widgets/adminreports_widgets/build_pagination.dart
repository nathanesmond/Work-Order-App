import 'package:flutter/material.dart';
import 'package:workorderapp/auth/work_order_provider.dart';

Widget buildPagination(WorkOrderProvider provider) {
  final totalPages = (provider.totalRows / provider.rowsPerPage).ceil();

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        icon: const Icon(Icons.chevron_left),
        onPressed: provider.currentPage > 1
            ? () => provider.changePage(provider.currentPage - 1)
            : null,
      ),
      Text("Page ${provider.currentPage} of $totalPages"),
      IconButton(
        icon: const Icon(Icons.chevron_right),
        onPressed: provider.currentPage < totalPages
            ? () => provider.changePage(provider.currentPage + 1)
            : null,
      ),
    ],
  );
}
