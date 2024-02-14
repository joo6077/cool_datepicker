import 'package:cool_datepicker/controllers/datepicker_controller.dart';
import 'package:cool_datepicker/controllers/range_datepicker_controller.dart';
import 'package:cool_datepicker/library/utils/date_time_extension.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DatepickerOptions implements TickerProvider {
  final List<DateTime> disabledList;
  final List<DateTimeRange> disabledRangeList;

  final Map<DateTime, List<DateTime>> _disabledDatesMap = {};

  DatepickerOptions({
    this.disabledList = const [],
    this.disabledRangeList = const [],
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

  List<MultipleItem?> initializeSingle({
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

    final days = List<MultipleItem?>.filled(42, null);

    for (var i = 0; i < lastDay; i++) {
      final day = i + 1;
      final index = i + startDayOffset;
      final currentDate = DateTime(date.year, date.month, day);
      final isDisabled = disabledDates.contains(currentDate);
      final isSelected = selectedDates.contains(currentDate);
      days[index] = MultipleItem(
        date: currentDate,
        index: index,
        isDisabled: isDisabled,
        isSelected: isSelected,
      );
    }

    return days;
  }

  // RangeModel initializeRange({
  //   required DateTime date,
  //   required WeekDay firstDayOfWeek,
  //   required RangeDatepickerController datepickerController,
  //   DateTime? startDate,
  //   DateTime? endDate,
  // }) {
  //   final firstOfMonth = DateTime(date.year, date.month);
  //   final lastOfMonth = DateTime(date.year, date.month + 1, 0);

  //   int startDayOffset = (firstOfMonth.weekday - firstDayOfWeek.index) % 7;
  //   if (startDayOffset < 0) {
  //     startDayOffset += 7;
  //   }

  //   final lastDay = lastOfMonth.day;

  //   final disabledDates = _getDisabledDates(date);

  //   final days = List<RangeItemModel?>.filled(42, null);

  //   int startDateIndex = -1;
  //   int endDateIndex = -1;

  //   for (var i = 0; i < lastDay; i++) {
  //     final day = i + 1;
  //     final index = i + startDayOffset;
  //     final currentDate = DateTime(date.year, date.month, day);
  //     final isDisabled = disabledDates.contains(currentDate);
  //     days[index] = RangeItemModel(
  //       date: currentDate,
  //       index: index,
  //       isDisabled: isDisabled,
  //     );

  //     if (startDate != null && startDate.isSameDay(currentDate)) {
  //       startDateIndex = index;
  //     }

  //     if (endDate != null && endDate.isSameDay(currentDate)) {
  //       endDateIndex = index;
  //     }
  //   }

  //   return RangeModel(
  //     start: startDate != null
  //         ? RangeItemModel(
  //             date: startDate,
  //             index: startDateIndex,
  //             isDisabled: false,
  //           )
  //         : null,
  //     end: endDate != null
  //         ? RangeItemModel(
  //             date: endDate,
  //             index: endDateIndex,
  //             isDisabled: false,
  //           )
  //         : null,
  //   );
  // }

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
