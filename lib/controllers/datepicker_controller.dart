import 'package:flutter/material.dart';

class DatepickerController {
  Map<DateTime, List<DateItem>> _selectedYearMonthMap = {};

  Map<DateTime, List<DateItem>> get selectedDates => _selectedYearMonthMap;

  void addSelectedDate(DateTime currentYearMonth, int day, int index,
      AnimationController controller) {
    final dateItem = DateItem(
        day: DateTime(currentYearMonth.year, currentYearMonth.month, day),
        index: index);
    if (_selectedYearMonthMap.containsKey(currentYearMonth)) {
      if (_selectedYearMonthMap[currentYearMonth]!.contains(dateItem)) {
        _selectedYearMonthMap[currentYearMonth]!.remove(dateItem);
        controller.reverse();
      } else {
        _selectedYearMonthMap[currentYearMonth]!.add(dateItem);
        controller.forward();
      }
    } else {
      _selectedYearMonthMap[currentYearMonth] = [dateItem];
      controller.forward();
    }
  }

  // convert selectedDates to List<DateTime>
  List<DateTime> getSelectedDates() {
    List<DateTime> selectedDates = [];
    _selectedYearMonthMap.forEach((key, value) {
      selectedDates.add(key);
    });
    return selectedDates;
  }
}

class DateItem {
  final DateTime day;
  final int index;

  DateItem({
    required this.day,
    required this.index,
  });

  // operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateItem && other.day == day && other.index == index;
  }
}
