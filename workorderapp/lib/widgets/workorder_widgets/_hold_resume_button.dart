import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/widgets/workorder_widgets/_comment_dialog.dart';
import '../../auth/work_order_provider.dart';

class HoldResumeButton extends StatelessWidget {
  final int workOrderId;
  final bool isOnHold;

  const HoldResumeButton({required this.workOrderId, required this.isOnHold});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        String? comment;
        if (!isOnHold) {
          comment = await showCommentDialog(
            context,
            title: 'Hold Work Order',
            action: 'Hold',
          );
          if (comment == null) return;
        }

        if (isOnHold) {
          await context.read<WorkOrderProvider>().resume(workOrderId);
        } else {
          await context.read<WorkOrderProvider>().hold(
            workOrderId,
            comment: comment,
          );
        }
      },
      icon: Icon(
        isOnHold ? Icons.play_arrow : Icons.pause,
        size: 16,
        color: Colors.white,
      ),
      label: Text(
        isOnHold ? 'Resume' : 'Hold',
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isOnHold ? Colors.blue : Colors.orange,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
