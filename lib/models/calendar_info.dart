import 'package:flutter/material.dart';
import 'package:cool_datepicker/enums/SelectType.dart';
import 'package:cool_datepicker/models/date_info.dart';
import 'package:cool_datepicker/models/dates_range.dart';
import 'package:cool_datepicker/library/utils/extension_util.dart';

class CalendarInfo {
  late int year;
  late int month;
  List<DateInfo> dates = [];
  late dynamic thisVsync;

  CalendarInfo({required this.year, required this.month, this.thisVsync, required int firstWeekDay}) {
    int lastDay = DateTime(year, month + 1, 0).day;
    int monthFirstWeekDay = DateTime(year, month, 1).weekday;

    for (int i = 0; i < (monthFirstWeekDay - firstWeekDay) %7; i++) {
      dates.add(DateInfo(isSelected: SelectType.empty));
    }



    for (var i = 0; i < lastDay; i++) {
      AnimationController singleSelectedAniCtrl = AnimationController(
          vsync: thisVsync, duration: const Duration(milliseconds: 500));
      Animation<double> singleScaleTransition = Tween<double>(begin: 0, end: 1)
          .animate(CurvedAnimation(
              parent: singleSelectedAniCtrl,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeInQuad));
      dates.add(DateInfo(
          date: i + 1,
          weekday: DateTime(year, month, i + 1).weekday,
          isSelected: SelectType.none,
          singleSelectedAniCtrl: singleSelectedAniCtrl,
          singleScaleAnimation: singleScaleTransition));
    }
  }

  void setCurrentMonth(DateTime target, SelectType type) {
    if (target.year == year && target.month == month) {
      dates.singleWhere((date) => date.date == target.day).isSelected = type;
    }
  }

  void setCurrentMonthRange(
      {required DateTime startDt,
      required DateTime endDt,
      required SelectType type}) {
    startDt.getBtwDates(end: endDt).forEach((btwDate) {
      setCurrentMonth(btwDate, type);
    });
    setCurrentMonth(startDt, type);
    setCurrentMonth(endDt, type);
  }

  void setSelectedDates(
      {required List<DateTime> selectedDates,
      List<DateTime>? disabledList,
      List<Map<String, DateTime?>>? disabledRangeList}) {
    for (var selectedDate in selectedDates) {
      setCurrentMonth(selectedDate, SelectType.selected);
    }
    setDisabledDates(
        disabledList: disabledList, disabledRangeList: disabledRangeList);
  }

  bool isSameYearMonth(DateTime target) {
    return (target.year == year) && (target.month == month);
  }

  void setDisabledDates(
      {List<DateTime>? disabledList,
      List<Map<String, DateTime?>>? disabledRangeList}) {
    if (disabledList != null) {
      for (var disabledDay in disabledList) {
        if (isSameYearMonth(disabledDay)) {
          setCurrentMonth(disabledDay, SelectType.disabled);
        }
      }
    }
    if (disabledRangeList != null) {
      for (var rangeMap in disabledRangeList) {
        if (rangeMap['start'] != null && rangeMap['end'] != null) {
          DateTime? currentMonthStartDate =
              rangeMap['start']!.setDisabledStartDate(calendarInfo: this);
          DateTime? currentMonthEndDate =
              rangeMap['end']!.setDisabledEndDate(calendarInfo: this);
          if (currentMonthStartDate != null && currentMonthEndDate != null) {
            setCurrentMonthRange(
                startDt: currentMonthStartDate,
                endDt: currentMonthEndDate,
                type: SelectType.disabled);
          }
        }
      }
    }
  }

  void setSelectedBtwDates(
      {required DatesRange datesRange,
      List<DateTime>? disabledList,
      List<Map<String, DateTime?>>? disabledRangeList}) {
    if (datesRange.start != null && datesRange.end != null) {
      datesRange.start!.getBtwDates(end: datesRange.end!).forEach((btwDate) {
        setCurrentMonth(btwDate, SelectType.between);
      });
      setCurrentMonth(datesRange.start!, SelectType.start);
      setCurrentMonth(datesRange.end!, SelectType.end);
    } else if (datesRange.start != null) {
      if (datesRange.start!.year == year && datesRange.start!.month == month) {
        dates
            .singleWhere((date) => date.date == datesRange.start!.day)
            .isSelected = SelectType.start;
      }
    }
    setDisabledDates(
        disabledList: disabledList, disabledRangeList: disabledRangeList);
  }
}
