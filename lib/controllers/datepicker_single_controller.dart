import 'package:cool_datepicker/library/utils/date_time_extension.dart';
import 'package:cool_datepicker/models/date_info_model.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/controllers/datepicker_controller.dart';

class DatepickerSingleController extends DatepickerController {
  final int maxCount;
  final List<DateInfoModel> _selectedDates = [];

  final Map<DateTime, List<DateInfoModel>> _selectedYearMonthMap = {};
  List<DateTime> get selectedDates =>
      _selectedDates.map((e) => e.date).toList();

  Map<DateTime, List<DateInfoModel>> get selectedYearMonthMap =>
      _selectedYearMonthMap;

  DatepickerSingleController({
    this.maxCount = 3,
    List<DateTime> selectedDates = const [],
    super.weekSettings = const WeekSettings(),
    super.monthSettings = MonthSettings.english,
    super.disabledList = const [],
    super.disabledRangeList = const [],
  }) {
    assert(maxCount > 0, 'maxCount must be greater than 0');
    assert(selectedDates.length <= maxCount,
        'selectedDates length must be less than or equal to maxCount');
    _setInitialSelectedDates(_convertDateTimeToModel(selectedDates));
  }

  List<DateInfoModel> _convertDateTimeToModel(List<DateTime> dates) => dates
      .map((e) =>
          DateInfoModel(date: e, index: getFirstDayOffset(e) + e.day - 1))
      .toList();

  void _setInitialSelectedDates(List<DateInfoModel> selectedDates) {
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

  DateInfoModel? onSelected(DateInfoModel item) {
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

  DateInfoModel? _addSelectedDate(DateInfoModel item) {
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

  DateInfoModel _removeSelectedDate(DateInfoModel item) {
    final dateKey = _monthKey(item.date);
    _selectedYearMonthMap[dateKey]!.remove(item);
    _selectedDates.remove(item);

    return item;
  }
}
