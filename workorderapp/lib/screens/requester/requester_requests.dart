import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/work_order_provider.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/create_request_modal.dart';
import 'package:workorderapp/widgets/workorder_widgets/_work_order_card.dart';
import 'package:workorderapp/widgets/workorder_widgets/status_filter.dart';

class RequesterRequests extends StatefulWidget {
  const RequesterRequests({super.key});

  @override
  State<RequesterRequests> createState() => _RequesterRequestsState();
}

class _RequesterRequestsState extends State<RequesterRequests> {
  String _selectedStatus = 'all';

  static const _statusOrder = [
    'on_request',
    'in_progress',
    'completed',
    'overdue',
    'cancelled',
  ];

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _hoursController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<WorkOrderProvider>();
      provider.searchQuery = '';
      provider.statusFilter = null;
      provider.fetchMyRequests();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  List<WorkOrder> _getFiltered(List<WorkOrder> orders) {
    List<WorkOrder> filtered = _selectedStatus == 'all'
        ? [...orders]
        : orders.where((w) => w.status == _selectedStatus).toList();

    if (_selectedStatus == 'all') {
      filtered.sort((a, b) {
        final s = _statusOrder
            .indexOf(a.status)
            .compareTo(_statusOrder.indexOf(b.status));
        if (s != 0) return s;
        if (a.dueAt == null && b.dueAt == null) return 0;
        if (a.dueAt == null) return 1;
        if (b.dueAt == null) return -1;
        return a.dueAt!.compareTo(b.dueAt!);
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkOrderProvider>();
    final filtered = _getFiltered(provider.workOrders);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFE),
      body: Column(
        children: [
          const SizedBox(height: 12),
          StatusFilter(
            selected: _selectedStatus,
            onChanged: (s) => setState(() => _selectedStatus = s),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final provider = context.read<WorkOrderProvider>();
                provider.searchQuery = ''; // ← sync state first
                provider.statusFilter = _selectedStatus;
                await provider.fetchMyRequests();
              },
              child: filtered.isEmpty
                  ? ListView(
                      // ← ListView not Center
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              'No active work orders',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => WorkOrderCard(item: filtered[i]),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBFE),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(26),
              onTap: () => showCreateRequestModal(context),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_circle, size: 26),
                    SizedBox(width: 10),
                    Text(
                      'Create Request',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
