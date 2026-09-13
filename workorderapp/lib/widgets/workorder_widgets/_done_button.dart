import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/work_order_provider.dart';

class DoneButton extends StatelessWidget {
  final int workOrderId;

  const DoneButton({required this.workOrderId});

  Future<bool?> _confirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Finish Work Order'),
        content: const Text('Are you sure you want to finish this work order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final ok = await _confirm(context);
        if (ok != true) return;
        await context.read<WorkOrderProvider>().complete(workOrderId);
      },
      icon: const Icon(Icons.check_circle, size: 16, color: Colors.white),
      label: const Text(
        'Finish',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
