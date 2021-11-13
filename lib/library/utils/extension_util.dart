// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:cool_datepicker/models/calendar_info.dart';

extension ReverseList on List<Widget> {
  List<Widget> isReverse(bool isReverse) {
    if (isReverse) {
      return this.reversed.toList();
    } else {
      return this;
    }
  }
}

extension ToSelectedDates on DateTime {
  DateTime tomorrow() {
    return DateTime(this.year, this.month, this.day + 1);
  }

  DateTime yesterday() {
    return DateTime(this.year, this.month, this.day - 1);
  }

  bool compare(DateTime target) {
    return (this.year == target.year) &&
        (this.month == target.month) &&
        (this.day == target.day);
  }

  List<DateTime> getBtwDates({required DateTime end}) {
    DateTime startDate = this.tomorrow();
    DateTime endDate = end.yesterday();
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
    }

    return days;
  }

  DateTime? setDisabledStartDate({required CalendarInfo calendarInfo}) {
    DateTime? result;
    if (this.year == calendarInfo.year) {
      if (this.month == calendarInfo.month) {
        result = this;
      }
      if (this.month < calendarInfo.month) {
        result = DateTime(calendarInfo.year, calendarInfo.month, 0);
      }
    } else if (this.year < calendarInfo.year) {
      result = DateTime(calendarInfo.year, calendarInfo.month, 0);
    }
    return result;
  }

  DateTime? setDisabledEndDate({required CalendarInfo calendarInfo}) {
    DateTime? result;
    if (this.year == calendarInfo.year) {
      if (this.month == calendarInfo.month) {
        result = this;
      }
      if (this.month > calendarInfo.month) {
        result = DateTime(calendarInfo.year, calendarInfo.month + 1, 1);
      }
    } else if (this.year > calendarInfo.year) {
      result = DateTime(calendarInfo.year, calendarInfo.month + 1, 1);
    }
    return result;
  }

  bool checkAfter({required DateTime target}) {
    bool checkYear = false;
    bool checkMonth = false;
    bool checkDay = false;
    // startDate < targetDate
    if (this.year == target.year) {
      checkYear = true;
      if (this.month == target.month) {
        checkMonth = true;
        if (this.day > target.day) {
          checkDay = false;
        } else {
          checkDay = true;
        }
      } else if (this.month < target.month) {
        checkMonth = true;
        checkDay = true;
      }
    } else if (this.year < target.year) {
      checkYear = true;
      checkMonth = true;
      checkDay = true;
    }
    return checkYear && checkMonth && checkDay;
  }

  bool checkBefore({required DateTime target}) {
    bool checkYear = false;
    bool checkMonth = false;
    bool checkDay = false;

    if (this.year == target.year) {
      checkYear = true;
      if (this.month == target.month) {
        checkMonth = true;
        if (this.day < target.day) {
          checkDay = false;
        } else {
          checkDay = true;
        }
      } else if (this.month > target.month) {
        checkMonth = true;
        checkDay = true;
      }
    } else if (this.year > target.year) {
      checkYear = true;
      checkMonth = true;
      checkDay = true;
    }
    return checkYear && checkMonth && checkDay;
  }
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}

extension StringUtils on String {
  Size getTextWidth(TextStyle style, BuildContext context) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.size;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

  Color subHex(String target) {
    int bigNum = int.parse(this.value.toString(), radix: 16);
    int smallNum = int.parse(target, radix: 16);
    int result = bigNum - smallNum;
    return Color(result);
  }
}
