import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorderapp/entity/comment.dart';
import 'package:workorderapp/entity/work_order.dart';
import 'package:workorderapp/widgets/workorder_widgets/_cancel_button.dart';

void showWorkOrderDetail(BuildContext context, WorkOrder item) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _WorkOrderDetailSheet(item: item),
  );
}

class _WorkOrderDetailSheet extends StatelessWidget {
  final WorkOrder item;

  const _WorkOrderDetailSheet({required this.item});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy • HH:mm').format(date.toLocal());
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'on_request':
        return Colors.orange;
      case 'in_progress':
        return Colors.purple;
      case 'on_hold':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'on_request':
        return Icons.inbox_rounded;
      case 'in_progress':
        return Icons.autorenew_rounded;
      case 'on_hold':
        return Icons.pause_circle_outline_rounded;
      case 'completed':
        return Icons.check_circle_outline_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'overdue':
        return Icons.warning_amber_rounded;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = item.status;
    final statusColor = _statusColor(status);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFBFE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
                children: [
                  // status icon + badge + title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _statusIcon(status),
                          color: statusColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status.replaceAll('_', ' ').toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                            letterSpacing: .4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.person_outline,
                          label: 'Requester',
                          value: item.requester.name,
                        ),
                        _Separator(),
                        _InfoRow(
                          icon: Icons.apartment,
                          label: 'Department',
                          value: item.department?.name ?? '-',
                        ),
                        _Separator(),
                        _InfoRow(
                          icon: Icons.flag_outlined,
                          label: 'Due',
                          value: _formatDate(item.dueAt),
                          valueColor:
                              item.dueAt != null &&
                                  item.dueAt!.isBefore(DateTime.now()) &&
                                  status != 'completed' &&
                                  status != 'cancelled'
                              ? Colors.red
                              : null,
                        ),
                        _Separator(),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Created',
                          value: _formatDate(item.createdAt),
                        ),

                        if (status == 'in_progress' || status == 'on_hold') ...[
                          _Separator(),
                          _InfoRow(
                            icon: Icons.engineering_outlined,
                            label: 'Engineer',
                            value: item.engineer?.name ?? '-',
                          ),
                          _Separator(),
                          _InfoRow(
                            icon: Icons.play_circle_outline,
                            label: 'Started',
                            value: _formatDate(item.startedAt),
                          ),
                        ],

                        if (status == 'completed') ...[
                          _Separator(),
                          _InfoRow(
                            icon: Icons.engineering_outlined,
                            label: 'Engineer',
                            value: item.engineer?.name ?? '-',
                          ),
                          _Separator(),
                          _InfoRow(
                            icon: Icons.play_circle_outline,
                            label: 'Started',
                            value: _formatDate(item.startedAt),
                          ),
                          _Separator(),
                          _InfoRow(
                            icon: Icons.check_circle_outline,
                            label: 'Completed',
                            value: _formatDate(item.completedAt),
                            valueColor: Colors.green,
                          ),
                        ],

                        if (status == 'cancelled') ...[
                          _Separator(),
                          _InfoRow(
                            icon: Icons.person_off_outlined,
                            label: 'Cancelled By',
                            value: item.cancelledByUser?.name ?? '-',
                          ),
                          _Separator(),
                          _InfoRow(
                            icon: Icons.apartment,
                            label: 'From',
                            value:
                                item.cancelledByUser?.department?.name ?? '-',
                          ),
                          _Separator(),
                          _InfoRow(
                            icon: Icons.event_busy_outlined,
                            label: 'Cancelled At',
                            value: _formatDate(item.cancelledAt),
                            valueColor: Colors.grey,
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (item.comments.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 15,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${item.comments.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...item.comments.map((c) => _CommentItem(comment: c)),
                  ],

                  if (item.status == 'on_request') ...[
                    const SizedBox(height: 20),
                    CancelButton(
                      workOrderId: item.id,
                      onSuccess: () => Navigator.pop(context),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 17, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade100,
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;

  const _CommentItem({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    comment.user.name.isNotEmpty
                        ? comment.user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                comment.createdAt != null
                    ? DateFormat(
                        'dd MMM • HH:mm',
                      ).format(comment.createdAt!.toLocal())
                    : '',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.comment,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
