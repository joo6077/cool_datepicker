import 'package:cool_datepicker/controllers/datepicker_controller.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DatepickerOptions implements TickerProvider {
  final List<DateTime> disabledList;
  final List<DateTimeRange> disabledRangeList;
  final int maxCount;

  final Map<DateTime, List<DateTime>> _disabledDatesMap = {};

  DatepickerOptions({
    this.disabledList = const [],
    this.disabledRangeList = const [],
    this.maxCount = 1,
  }) {
    _setDisabledDatesMap();
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

  List<DatepickerMultipleItem?> initializeDays({
    required DateTime date,
    required WeekDay firstDayOfWeek,
    required List<DateTime> selectedDates,
  }) {
    final firstOfMonth = DateTime(date.year, date.month);
    final lastOfMonth = DateTime(date.year, date.month + 1, 0);

    int startDayOffset = (firstOfMonth.weekday - firstDayOfWeek.index) % 7;
    if (startDayOffset < 0) {
      startDayOffset += 7;
    }

    final lastDay = lastOfMonth.day;

    final disabledDates = _getDisabledDates(date);

    final days = List<DatepickerMultipleItem?>.filled(42, null);

    for (var i = 0; i < lastDay; i++) {
      final day = i + 1;
      final index = i + startDayOffset;
      final currentDate = DateTime(date.year, date.month, day);
      final isDisabled = disabledDates.contains(currentDate);
      final isSelected = selectedDates.contains(currentDate);
      days[index] = DatepickerMultipleItem(
        date: currentDate,
        index: index,
        isDisabled: isDisabled,
        isSelected: isSelected,
        timestamp: currentDate.millisecondsSinceEpoch,
      );
    }

    return days;
  }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
