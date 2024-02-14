import 'package:cool_datepicker/models/date_info_model.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:flutter/material.dart';

class DatepickerController {
  final WeekSettings weekSettings;
  final MonthSettings monthSettings;

  final List<DateTime> disabledList;
  final List<DateTimeRange> disabledRangeList;

  final Map<DateTime, List<DateTime>> _disabledDatesMap = {};

  DatepickerController({
    required this.weekSettings,
    required this.monthSettings,
    required this.disabledList,
    required this.disabledRangeList,
  }) {
    _setDisabledDatesMap();
  }

  int getFirstDayOffset(DateTime date) {
    final firstOfMonth = DateTime(date.year, date.month);
    return (firstOfMonth.weekday - weekSettings.firstDayOfWeek.index) % 7;
  }

  /// set disabled dates. Key is the year month of the date, value is the list of dates that are disabled
  void _setDisabledDatesMap() {
    _disabledDatesMap.clear();
    for (var range in disabledRangeList) {
      for (var i = range.start;
          i.isBefore(range.end);
          i = i.add(const Duration(days: 1))) {
        if (_disabledDatesMap.containsKey(i)) {
          _disabledDatesMap[i]!.add(i);
        } else {
          _disabledDatesMap[i] = [i];
        }
      }
    }

    for (var date in disabledList) {
      if (_disabledDatesMap.containsKey(date)) {
        _disabledDatesMap[date]!.add(date);
      } else {
        _disabledDatesMap[date] = [date];
      }
    }
  }

  /// get the disabled dates for the year and month
  /// returns a list of dates that are disabled
  List<DateTime> _getDisabledDates(DateTime date) => _disabledDatesMap.entries
      .where((element) =>
          element.key.year == date.year && element.key.month == date.month)
      .map((e) => e.key)
      .toList();

  List<DateInfoModel?> initializeDate({
    required DateTime date,
    required List<DateTime> selectedDates,
  }) {
    final lastOfMonth = DateTime(date.year, date.month + 1, 0);

    int startDayOffset = getFirstDayOffset(date);
    if (startDayOffset < 0) {
      startDayOffset += 7;
    }

    final lastDay = lastOfMonth.day;

    final disabledDates = _getDisabledDates(date);

    final days = List<DateInfoModel?>.filled(42, null);

    for (var i = 0; i < lastDay; i++) {
      final day = i + 1;
      final index = i + startDayOffset;
      final currentDate = DateTime(date.year, date.month, day);
      final isDisabled = disabledDates.contains(currentDate);
      days[index] = DateInfoModel(
        date: currentDate,
        index: index,
        isDisabled: isDisabled,
      );
    }

    return days;
  }
}
