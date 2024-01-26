import 'package:flutter/material.dart';

class DayOfWeek {
  final Day monday;
  final Day tuesday;
  final Day wednesday;
  final Day thursday;
  final Day friday;
  final Day saturday;
  final Day sunday;

  const DayOfWeek({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  // copyWith
  DayOfWeek copyWith({
    Day? monday,
    Day? tuesday,
    Day? wednesday,
    Day? thursday,
    Day? friday,
    Day? saturday,
    Day? sunday,
  }) {
    return DayOfWeek(
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  List<Day> get list {
    return [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
    ];
  }

  // Korean
  static DayOfWeek get korean {
    return const DayOfWeek(
      monday: Day(
        text: '월',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      tuesday: Day(
        text: '화',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      wednesday: Day(
        text: '수',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      thursday: Day(
        text: '목',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      friday: Day(
        text: '금',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      saturday: Day(
        text: '토',
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue,
        ),
      ),
      sunday: Day(
        text: '일',
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
        ),
      ),
    );
  }

  // English
  static DayOfWeek get english {
    return const DayOfWeek(
      monday: Day(
        text: 'M',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      tuesday: Day(
        text: 'T',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      wednesday: Day(
        text: 'W',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      thursday: Day(
        text: 'T',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      friday: Day(
        text: 'F',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      saturday: Day(
        text: 'S',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      sunday: Day(
        text: 'S',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'DayOfWeek{monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday}';
  }
}

class Day {
  final String text;
  final TextStyle style;

  const Day({
    required this.text,
    required this.style,
  });

  // copyWith
  Day copyWith({
    String? text,
    TextStyle? style,
  }) {
    return Day(
      text: text ?? this.text,
      style: style ?? this.style,
    );
  }

  @override
  String toString() {
    return 'Day{text: $text, style: $style}';
  }
}
