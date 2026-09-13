import 'package:flutter/material.dart';
import 'package:workorderapp/widgets/workorder_widgets/_due_timer_state.dart';

class DueTimer extends StatefulWidget {
  final DateTime dueAt;

  const DueTimer({required this.dueAt});

  @override
  State<DueTimer> createState() => DueTimerState();
}
