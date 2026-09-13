import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_meta.dart';
import 'package:workorderapp/widgets/workorder_widgets/_due_timer.dart';
import 'package:workorderapp/widgets/workorder_widgets/_cancel_button.dart';
import 'package:workorderapp/widgets/workorder_widgets/work_order_details.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrder item;
  final bool showActions;
  final Widget? claimButton;
  const WorkOrderCard({
    required this.item,
    this.showActions = true,
    this.claimButton,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'on_request':
        return Colors.orange;
      case 'in_progress':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.black;
      case 'overdue':
        return Colors.red;
      case 'on_hold':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String formatDueDate(DateTime? date) {
    if (date == null) return "-";

    return DateFormat('EEEE, dd-MM-yyyy - HH:mm').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    final statusLabel = status.replaceAll("_", " ").toUpperCase();
    return GestureDetector(
      onTap: () => showWorkOrderDetail(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFE),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(status),
                        letterSpacing: .4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Meta(
                    icon: Icons.apartment,
                    label: item.department?.name ?? '-',
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Meta(icon: Icons.person, label: item.requester.name),
                  ),
                  if (item.dueAt != null && item.status == 'on_request' ||
                      item.status == 'in_progress')
                    Row(
                      children: [
                        DueTimer(dueAt: item.dueAt!),
                        SizedBox(width: 8),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 14),

              Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

              const SizedBox(height: 12),

              if (claimButton != null) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [claimButton!],
                ),
              ] else if (showActions) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (item.status != 'cancelled' &&
                        item.status != 'completed') ...[
                      const SizedBox(width: 6),
                      CancelButton(workOrderId: item.id),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
