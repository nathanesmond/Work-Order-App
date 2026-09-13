import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_claim_button.dart';
import 'package:workorderapp/widgets/workorder_widgets/_work_order_card.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_search.dart';
import '../../auth/work_order_provider.dart';

class EngineerHome extends StatefulWidget {
  const EngineerHome({super.key});

  @override
  State<EngineerHome> createState() => _EngineerHomeState();
}

class _EngineerHomeState extends State<EngineerHome> {
  String _search = '';
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
    provider.searchQuery = _search;
    provider.fetchAvailable();
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      setState(() => _search = q);
      _syncAndFetch();
    });
  }

  List<WorkOrder> _getSorted(List<WorkOrder> orders) {
    final sorted = [...orders];
    sorted.sort((a, b) {
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();
    final sorted = _getSorted(provider.workOrders);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFE),
      body: Column(
        children: [
          WorkOrderSearch(onSearch: _onSearch),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: provider.fetchAvailable,
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : sorted.isEmpty
                  ? const Center(
                      child: Text(
                        'No available work orders',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: sorted.length,
                      itemBuilder: (_, i) => WorkOrderCard(
                        item: sorted[i],
                        showActions: false,
                        claimButton: ClaimButton(workOrderId: sorted[i].id),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
