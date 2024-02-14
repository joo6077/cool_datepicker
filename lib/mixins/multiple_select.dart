import 'package:cool_datepicker/controllers/datepicker_controller.dart';
import 'package:cool_datepicker/library/utils/date_time_extension.dart';

class MultipleSelect {
  final int maxCount;
  final List<MultipleItem> _selectedDates = [];

  final Map<DateTime, List<MultipleItem>> _selectedYearMonthMap = {};
  List<DateTime> get selectedDates =>
      _selectedDates.map((e) => e.date).toList();

  Map<DateTime, List<MultipleItem>> get selectedYearMonthMap =>
      _selectedYearMonthMap;

  MultipleSelect({
    this.maxCount = 3,
    List<MultipleItem> selectedDates = const [],
  }) {
    assert(maxCount > 0, 'maxCount must be greater than 0');
    assert(selectedDates.length <= maxCount,
        'selectedDates length must be less than or equal to maxCount');
    _setInitialSelectedDates(selectedDates);
  }

  void _setInitialSelectedDates(List<MultipleItem> selectedDates) {
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

  MultipleItem? onSelected(MultipleItem item) {
    final dateKey = _monthKey(item.date);

    if (_selectedYearMonthMap.containsKey(dateKey)) {
      if (_selectedYearMonthMap[dateKey]!.contains(item)) {
        final removeItem = _removeSelectedDate(item);
        if (item.date.isCurrentMonth(removeItem.date)) {
          return removeItem;
        }
      } else {
        final removeItem = _addSelectedDate(item);
        if (removeItem != null && item.date.isCurrentMonth(removeItem.date)) {
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

    return null;
  }

  MultipleItem? _addSelectedDate(MultipleItem item) {
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

  MultipleItem _removeSelectedDate(MultipleItem item) {
    final dateKey = _monthKey(item.date);
    _selectedYearMonthMap[dateKey]!.remove(item);
    _selectedDates.remove(item);

    return item;
  }
}
