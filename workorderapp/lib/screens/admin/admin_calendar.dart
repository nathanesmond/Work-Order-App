import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth/calendar_provider.dart';
import '../../entity/calendar_day.dart';

class AdminCalendar extends StatefulWidget {
  const AdminCalendar({super.key});

  @override
  State<AdminCalendar> createState() => _AdminCalendarState();
}

class _AdminCalendarState extends State<AdminCalendar> {
  late DateTime _start;
  late DateTime _end;
  final _scrollController = ScrollController();
  final _headerScrollController = ScrollController();

  static const double _rowHeight = 52.0;
  static const double _labelWidth = 110.0;
  static const double _dayWidth = 38.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_headerScrollController.hasClients) {
        _headerScrollController.jumpTo(_scrollController.offset);
      }
    });
    final now = DateTime.now();
    _start = DateTime(now.year, now.month, 1);
    _end = DateTime(now.year, now.month + 1, 0);
    Future.microtask(
      () =>
          context.read<CalendarProvider>().fetchGantt(start: _start, end: _end),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerScrollController.dispose();

    super.dispose();
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
        return Colors.blueGrey;
    }
  }

  List<DateTime> get _days {
    final days = <DateTime>[];
    var d = _start;
    while (!d.isAfter(_end)) {
      days.add(d);
      d = d.add(const Duration(days: 1));
    }
    return days;
  }

  // clamp bar to visible range
  DateTime _clamp(DateTime d) {
    if (d.isBefore(_start)) return _start;
    if (d.isAfter(_end)) return _end;
    return d;
  }

  double _dayOffset(DateTime d) {
    final clamped = _clamp(d);
    return clamped.difference(_start).inDays * _dayWidth;
  }

  double _barWidth(CalendarOrder order) {
    final s = _clamp(order.createdAt ?? _start);
    final e = _clamp(order.dueAt ?? order.completedAt ?? _end);
    final days = e.difference(s).inDays + 1;
    return (days < 1 ? 1 : days) * _dayWidth;
  }

  void _showSummary(BuildContext context, CalendarOrder order) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withOpacity(.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(order.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _summaryRow(
                Icons.person_outline,
                'Requester',
                order.requester ?? '-',
              ),
              _summaryRow(
                Icons.apartment,
                'Department',
                order.department ?? '-',
              ),
              _summaryRow(
                Icons.engineering,
                'Engineer',
                order.engineer ?? 'Unassigned',
              ),
              _summaryRow(
                Icons.calendar_today,
                'Created',
                _fmt(order.createdAt),
              ),
              _summaryRow(Icons.flag_outlined, 'Due', _fmt(order.dueAt)),
              if (order.completedAt != null)
                _summaryRow(
                  Icons.check_circle_outline,
                  'Completed',
                  _fmt(order.completedAt),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? d) =>
      d != null ? DateFormat('dd MMM yyyy').format(d) : '-';

  void _prevMonth() {
    setState(() {
      _start = DateTime(_start.year, _start.month - 1, 1);
      _end = DateTime(_start.year, _start.month + 1, 0);
    });
    context.read<CalendarProvider>().fetchGantt(start: _start, end: _end);
  }

  void _nextMonth() {
    setState(() {
      _start = DateTime(_start.year, _start.month + 1, 1);
      _end = DateTime(_start.year, _start.month + 1, 0);
    });
    context.read<CalendarProvider>().fetchGantt(start: _start, end: _end);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();
    final days = _days;
    final today = DateTime.now();
    final orders = provider.orders;

    return Container(
      color: const Color(0xFFFFFBFE),
      child: Column(
        children: [
          // month navigator
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: _prevMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(_start),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 12,
              runSpacing: 6,
              children:
                  [
                        'on_request',
                        'in_progress',
                        'on_hold',
                        'completed',
                        'overdue',
                        'cancelled',
                      ]
                      .map(
                        (s) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _statusColor(s),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              s.replaceAll('_', ' '),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),

          if (orders.length >= 100)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 13,
                    color: Colors.orange.shade400,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Showing first 100 orders. Use filters to narrow results.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade600,
                    ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          if (provider.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
            )
          else if (orders.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No work orders this month',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: _labelWidth,
                        height: _rowHeight,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.fromLTRB(8, 0, 4, 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBFE),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Text(
                            'Work Order',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: _headerScrollController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: SizedBox(
                            width: days.length * _dayWidth,
                            child: Row(
                              children: days.map((d) {
                                final isToday = isSameDay(d, today);
                                return Container(
                                  width: _dayWidth,
                                  height: _rowHeight,
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFBFE),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat(
                                          'E',
                                        ).format(d).substring(0, 1),
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: isToday
                                              ? const Color.fromRGBO(
                                                  159,
                                                  125,
                                                  76,
                                                  1,
                                                )
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: isToday
                                            ? const BoxDecoration(
                                                color: Color.fromRGBO(
                                                  159,
                                                  125,
                                                  76,
                                                  1,
                                                ),
                                                shape: BoxShape.circle,
                                              )
                                            : null,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${d.day}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isToday
                                                ? FontWeight.w700
                                                : FontWeight.w400,
                                            color: isToday
                                                ? Colors.white
                                                : d.weekday ==
                                                          DateTime.saturday ||
                                                      d.weekday ==
                                                          DateTime.sunday
                                                ? Colors.red.shade300
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      // ← vertical scroll for rows
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // fixed label column
                          SizedBox(
                            width: _labelWidth,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: orders.length,
                              itemBuilder: (_, i) {
                                final order = orders[i];
                                return Container(
                                  height: _rowHeight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade100,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '#${order.id} ${order.title}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              controller:
                                  _scrollController, // ← drives the header
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                width: days.length * _dayWidth,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: orders.length,
                                  itemBuilder: (_, i) {
                                    final order = orders[i];
                                    final barStart = _clamp(
                                      order.createdAt ?? _start,
                                    );
                                    final offsetX = _dayOffset(barStart);
                                    final barW = _barWidth(order);
                                    final color = _statusColor(order.status);
                                    final isOverdue =
                                        order.status == 'overdue' ||
                                        (order.dueAt != null &&
                                            order.dueAt!.isBefore(today) &&
                                            order.status != 'completed' &&
                                            order.status != 'cancelled');

                                    return Container(
                                      height: _rowHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade100,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          ...days
                                              .where(
                                                (d) =>
                                                    d.weekday ==
                                                        DateTime.saturday ||
                                                    d.weekday ==
                                                        DateTime.sunday,
                                              )
                                              .map(
                                                (d) => Positioned(
                                                  left:
                                                      d
                                                          .difference(_start)
                                                          .inDays *
                                                      _dayWidth,
                                                  top: 0,
                                                  bottom: 0,
                                                  width: _dayWidth,
                                                  child: Container(
                                                    color: Colors.grey
                                                        .withOpacity(.04),
                                                  ),
                                                ),
                                              ),

                                          if (!today.isBefore(_start) &&
                                              !today.isAfter(_end))
                                            Positioned(
                                              left:
                                                  today
                                                          .difference(_start)
                                                          .inDays *
                                                      _dayWidth +
                                                  _dayWidth / 2,
                                              top: 0,
                                              bottom: 0,
                                              width: 1.5,
                                              child: Container(
                                                color: Colors.red.withOpacity(
                                                  .4,
                                                ),
                                              ),
                                            ),

                                          Positioned(
                                            left: offsetX + 2,
                                            top: 10,
                                            width: barW - 4,
                                            height: _rowHeight - 20,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _showSummary(context, order),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: color.withOpacity(.85),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: isOverdue
                                                      ? Border.all(
                                                          color: Colors.red,
                                                          width: 1.5,
                                                        )
                                                      : null,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                    ),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  order.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
