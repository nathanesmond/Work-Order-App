import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workorderapp/widgets/workorder_widgets/_due_timer.dart';

class DueTimerState extends State<DueTimer> {
  late DateTime _due;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _due = widget.dueAt;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _label() {
    final diff = _due.difference(DateTime.now());

    if (diff.isNegative) return 'OVERDUE';

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m left';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m left';
    }

    return '${diff.inDays}d left';
  }

  Color _color() {
    final diff = _due.difference(DateTime.now());

    if (diff.isNegative) return Colors.red;

    if (diff.inMinutes < 60) return Colors.orange;

    return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.timer, size: 16, color: _color()),
        const SizedBox(width: 6),
        Text(
          _label(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _color(),
          ),
        ),
      ],
    );
  }
}
