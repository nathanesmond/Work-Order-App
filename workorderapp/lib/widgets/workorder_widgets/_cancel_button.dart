import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workorderapp/auth/work_order_provider.dart';
import 'package:workorderapp/widgets/workorder_widgets/_comment_dialog.dart';

class CancelButton extends StatelessWidget {
  final int workOrderId;
  final VoidCallback? onSuccess;

  const CancelButton({required this.workOrderId, this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final comment = await showCommentDialog(
          context,
          title: 'Cancel Work Order',
          action: 'Cancel',
        );
        if (comment == null) return;

        await context.read<WorkOrderProvider>().cancel(
          workOrderId,
          comment: comment,
        );
        onSuccess?.call();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}
