import 'package:flutter/material.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_work_order_card.dart';

class WorkOrderList extends StatelessWidget {
  final List<WorkOrder> orders;
  final Future<void> Function()? onRefresh;

  const WorkOrderList({super.key, required this.orders, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: orders.isEmpty
          ? ListView(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      'No work orders',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: orders.length,
              itemBuilder: (_, i) => WorkOrderCard(item: orders[i]),
            ),
    );
  }
}
