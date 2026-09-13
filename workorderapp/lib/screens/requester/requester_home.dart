import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/widgets/workorder_widgets/status_filter.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_list.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_search.dart';
import '../../auth/work_order_provider.dart';

class RequesterHome extends StatefulWidget {
  const RequesterHome({super.key});

  @override
  State<RequesterHome> createState() => _RequesterHomeState();
}

class _RequesterHomeState extends State<RequesterHome> {
  String status = "all";
  String search = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncAndFetch();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _syncAndFetch() {
    final provider = context.read<WorkOrderProvider>();
    provider.searchQuery = search;
    provider.statusFilter = status == 'all' ? null : status;
    provider.fetchAll();
  }

  void _onSearch(String q) {
    search = q;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _syncAndFetch);
  }

  void _onStatusChanged(String s) {
    setState(() => status = s);
    _syncAndFetch();
  }

  Future<void> _onRefresh() async {
    // ← add this
    final provider = context.read<WorkOrderProvider>();
    provider.searchQuery = search;
    provider.statusFilter = status == 'all' ? null : status; // ← fix this line
    await provider.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();

    return Column(
      children: [
        WorkOrderSearch(onSearch: _onSearch),
        const SizedBox(height: 12),
        StatusFilter(selected: status, onChanged: _onStatusChanged),
        const SizedBox(height: 12),
        Expanded(
          child: WorkOrderList(
            orders: provider.allWorkOrders,
            onRefresh: _onRefresh,
          ),
        ),
      ],
    );
  }
}
