extension DateTimeExtension on DateTime {
  bool isCurrentMonth(DateTime date) {
    return year == date.year && month == date.month;
  }

  bool isSameDay(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }
}
