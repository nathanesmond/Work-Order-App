import 'package:flutter/material.dart';
import '../client/api_calendar.dart';
import '../entity/calendar_day.dart';

class CalendarProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CalendarOrder> orders = [];
  DateTime rangeStart = DateTime.now().subtract(const Duration(days: 5));
  DateTime rangeEnd = DateTime.now().add(const Duration(days: 25));

  Future<void> fetchGantt({DateTime? start, DateTime? end}) async {
    isLoading = true;
    notifyListeners();

    rangeStart = start ?? rangeStart;
    rangeEnd = end ?? rangeEnd;

    final data = await ApiCalendar.fetchGantt(start: rangeStart, end: rangeEnd);

    orders = (data ?? []).map((j) => CalendarOrder.fromJson(j)).toList();

    isLoading = false;
    notifyListeners();
  }
}
