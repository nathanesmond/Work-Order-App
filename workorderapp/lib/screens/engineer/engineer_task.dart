import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_cancel_button.dart';
import 'package:workorderapp/widgets/workorder_widgets/_hold_resume_button.dart';
import 'package:workorderapp/widgets/workorder_widgets/_work_order_card.dart';
import 'package:workorderapp/widgets/workorder_widgets/_done_button.dart';
import 'package:workorderapp/widgets/workorder_widgets/status_filter.dart';
import '../../auth/work_order_provider.dart';

class EngineerTask extends StatefulWidget {
  const EngineerTask({super.key});

  @override
  State<EngineerTask> createState() => _EngineerTaskState();
}

class _EngineerTaskState extends State<EngineerTask> {
  String _selectedStatus = 'all';

  static const _statusOrder = [
    'in_progress',
    'on_hold',
    'on_request',
    'completed',
    'overdue',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WorkOrderProvider>().fetchMy();
    });
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

    return Container(
      color: const Color(0xFFFFFBFE),
      child: Column(
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
                await context.read<WorkOrderProvider>().fetchMy();
              },
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : filtered.isEmpty
                  ? ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              'No work orders',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => WorkOrderCard(
                        item: filtered[i],
                        showActions: false,
                        claimButton: filtered[i].status == 'in_progress'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HoldResumeButton(
                                    workOrderId: filtered[i].id,
                                    isOnHold: false,
                                  ),
                                  const SizedBox(width: 8),
                                  CancelButton(workOrderId: filtered[i].id),
                                  const SizedBox(width: 8),
                                  DoneButton(workOrderId: filtered[i].id),
                                ],
                              )
                            : filtered[i].status == 'on_hold'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HoldResumeButton(
                                    workOrderId: filtered[i].id,
                                    isOnHold: true,
                                  ),
                                  const SizedBox(width: 8),
                                  CancelButton(workOrderId: filtered[i].id),
                                ],
                              )
                            : null,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
