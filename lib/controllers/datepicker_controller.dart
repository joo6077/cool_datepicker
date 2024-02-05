import 'package:cool_datepicker/library/utils/date_time_extension.dart';
import 'package:flutter/material.dart';

class DatepickerController {
  final int maxCount;
  final List<DatepickerMultipleItem> _selectedDates = [];

  final Map<DateTime, List<DatepickerMultipleItem>> _selectedYearMonthMap = {};
  List<DateTime> get selectedDates =>
      _selectedDates.map((e) => e.date).toList();

  Map<DateTime, List<DatepickerMultipleItem>> get selectedYearMonthMap =>
      _selectedYearMonthMap;

  DatepickerController({
    this.maxCount = 3,
    List<DatepickerMultipleItem> selectedDates = const [],
  }) {
    assert(maxCount > 0, 'maxCount must be greater than 0');
    assert(selectedDates.length <= maxCount,
        'selectedDates length must be less than or equal to maxCount');
    _setInitialSelectedDates(selectedDates);
  }

  void _setInitialSelectedDates(List<DatepickerMultipleItem> selectedDates) {
    for (var item in selectedDates) {
      final dateKey = _monthKey(item.date);
      if (_selectedYearMonthMap.containsKey(dateKey)) {
        _selectedYearMonthMap[dateKey]!.add(item);
      } else {
        _selectedYearMonthMap[dateKey] = [item];
      }
      _selectedDates.add(item);
    }
  }

  DateTime _monthKey(DateTime date) => DateTime(date.year, date.month);

  DatepickerMultipleItem? onSelected(DatepickerMultipleItem item) {
    final dateKey = _monthKey(item.date);

    if (_selectedYearMonthMap.containsKey(dateKey)) {
      if (_selectedYearMonthMap[dateKey]!.contains(item)) {
        final removeItem = _removeSelectedDate(item);
        if (item.date.isCurrentMonth(removeItem.date)) {
          print('after remove: $_selectedDates');
          return removeItem;
        }
      } else {
        final removeItem = _addSelectedDate(item);
        if (removeItem != null && item.date.isCurrentMonth(removeItem.date)) {
          print('after add: $_selectedDates');
          return removeItem;
        }
      }
    } else {
      _selectedYearMonthMap[dateKey] = [item];
      _selectedDates.add(item);
      if (_selectedDates.length > maxCount) {
        final removeItem = _selectedDates.removeAt(0);
        final removeDateKey = _monthKey(removeItem.date);
        _selectedYearMonthMap[removeDateKey]!.remove(removeItem);
        return removeItem;
      }
    }

    print('nothing: $_selectedDates');

    return null;
  }

  DatepickerMultipleItem? _addSelectedDate(DatepickerMultipleItem item) {
    final dateKey = _monthKey(item.date);
    _selectedYearMonthMap[dateKey]!.add(item);
    _selectedDates.add(item);

    if (_selectedDates.length > maxCount) {
      final removeItem = _selectedDates.removeAt(0);
      final removeDateKey = _monthKey(removeItem.date);
      _selectedYearMonthMap[removeDateKey]!.remove(removeItem);
      return removeItem;
    }

    return null;
  }

  DatepickerMultipleItem _removeSelectedDate(DatepickerMultipleItem item) {
    final dateKey = _monthKey(item.date);
    _selectedYearMonthMap[dateKey]!.remove(item);
    _selectedDates.remove(item);

    return item;
  }
}

class DatepickerMultipleItem {
  final DateTime date;
  final int index;
  final bool isDisabled;
  final bool isSelected;
  final int timestamp;

  const DatepickerMultipleItem({
    required this.date,
    required this.index,
    this.isDisabled = false,
    this.isSelected = false,
    this.timestamp = 0,
  });

  DatepickerMultipleItem copyWith({
    DateTime? date,
    int? index,
    bool? isDisabled,
    bool? isSelected,
    int? timestamp,
    AnimationController? controller,
  }) {
    return DatepickerMultipleItem(
      date: date ?? this.date,
      index: index ?? this.index,
      isDisabled: isDisabled ?? this.isDisabled,
      isSelected: isSelected ?? this.isSelected,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // toString
  @override
  String toString() {
    return 'DatepickerMultipleItem(date: $date, index: $index, isDisabled: $isDisabled, isSelected: $isSelected, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DatepickerMultipleItem &&
        other.date == date &&
        other.index == index &&
        other.isDisabled == isDisabled &&
        other.timestamp == timestamp &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => date.hashCode ^ index.hashCode;
}
