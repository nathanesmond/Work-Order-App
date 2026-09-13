import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workorderapp/widgets/workorder_widgets/status_filter.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_list.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_search.dart';
import '../../auth/work_order_provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String status = "all";
  String search = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkOrderProvider>().fetchAll();
    });
  }

  Timer? _debounce;
  void refresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final provider = context.read<WorkOrderProvider>();
      provider.searchQuery = search;
      provider.statusFilter = status;
      provider.fetchAll();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();

    return Column(
      children: [
        WorkOrderSearch(
          onSearch: (q) {
            search = q;
            refresh();
          },
        ),
        const SizedBox(height: 12),
        StatusFilter(
          selected: status,
          onChanged: (s) {
            setState(() => status = s);
            refresh();
          },
        ),
        const SizedBox(height: 12),

        Expanded(child: WorkOrderList(orders: provider.allWorkOrders)),
      ],
    );
  }
}
