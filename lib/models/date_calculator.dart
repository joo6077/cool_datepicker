import 'package:cool_datepicker/models/day_of_week.dart';

class DateCalculator {
  static List<int> generateMonthDays(
      int year, int month, WeekDay firstDayOfWeek) {
    DateTime firstOfMonth = DateTime(year, month);
    DateTime lastOfMonth = DateTime(year, month + 1, 0);

    int startDayOffset = (firstOfMonth.weekday - firstDayOfWeek.index) % 7;
    if (startDayOffset < 0) {
      startDayOffset += 7;
    }

    int lastDay = lastOfMonth.day;

    List<int> days = List.filled(42, 0);

    for (int i = 0; i < lastDay; i++) {
      days[i + startDayOffset] = i + 1;
    }

    return days;
  }
}
