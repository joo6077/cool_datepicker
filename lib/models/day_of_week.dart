import 'package:flutter/material.dart';

enum WeekDay { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

class WeekSettings {
  final WeekDay firstDayOfWeek;
  final DayOfWeek dayOfWeek;

  const WeekSettings({
    this.firstDayOfWeek = WeekDay.sunday,
    this.dayOfWeek = DayOfWeek.english,
  });

  List<Day> get dayOfWeekList {
    switch (firstDayOfWeek) {
      case WeekDay.sunday:
        return [
          dayOfWeek.sunday,
          dayOfWeek.monday,
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
          dayOfWeek.friday,
          dayOfWeek.saturday,
        ];
      case WeekDay.monday:
        return [
          dayOfWeek.monday,
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
          dayOfWeek.friday,
          dayOfWeek.saturday,
          dayOfWeek.sunday,
        ];
      case WeekDay.tuesday:
        return [
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
          dayOfWeek.friday,
          dayOfWeek.saturday,
          dayOfWeek.sunday,
          dayOfWeek.monday,
        ];
      case WeekDay.wednesday:
        return [
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
          dayOfWeek.friday,
          dayOfWeek.saturday,
          dayOfWeek.sunday,
          dayOfWeek.monday,
          dayOfWeek.tuesday,
        ];
      case WeekDay.thursday:
        return [
          dayOfWeek.thursday,
          dayOfWeek.friday,
          dayOfWeek.saturday,
          dayOfWeek.sunday,
          dayOfWeek.monday,
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
        ];
      case WeekDay.friday:
        return [
          dayOfWeek.friday,
          dayOfWeek.saturday,
          dayOfWeek.sunday,
          dayOfWeek.monday,
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
        ];
      case WeekDay.saturday:
        return [
          dayOfWeek.saturday,
          dayOfWeek.sunday,
          dayOfWeek.monday,
          dayOfWeek.tuesday,
          dayOfWeek.wednesday,
          dayOfWeek.thursday,
          dayOfWeek.friday,
        ];
    }
  }
}

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

  // Korean
  static const DayOfWeek korean = DayOfWeek(
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

  // English
  static const DayOfWeek english = DayOfWeek(
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
        color: Colors.blue,
      ),
    ),
    sunday: Day(
      text: 'S',
      style: TextStyle(
        fontSize: 12,
        color: Colors.red,
      ),
    ),
  );

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

// month settings
class MonthSettings {
  final Month january;
  final Month february;
  final Month march;
  final Month april;
  final Month may;
  final Month june;
  final Month july;
  final Month august;
  final Month september;
  final Month october;
  final Month november;
  final Month december;

  const MonthSettings({
    required this.january,
    required this.february,
    required this.march,
    required this.april,
    required this.may,
    required this.june,
    required this.july,
    required this.august,
    required this.september,
    required this.october,
    required this.november,
    required this.december,
  });

  // copyWith
  MonthSettings copyWith({
    Month? january,
    Month? february,
    Month? march,
    Month? april,
    Month? may,
    Month? june,
    Month? july,
    Month? august,
    Month? september,
    Month? october,
    Month? november,
    Month? december,
  }) {
    return MonthSettings(
      january: january ?? this.january,
      february: february ?? this.february,
      march: march ?? this.march,
      april: april ?? this.april,
      may: may ?? this.may,
      june: june ?? this.june,
      july: july ?? this.july,
      august: august ?? this.august,
      september: september ?? this.september,
      october: october ?? this.october,
      november: november ?? this.november,
      december: december ?? this.december,
    );
  }

  // list
  List<Month> get list {
    return [
      january,
      february,
      march,
      april,
      may,
      june,
      july,
      august,
      september,
      october,
      november,
      december,
    ];
  }

  // Korean
  static const MonthSettings korean = MonthSettings(
    january: Month(
      text: '1월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    february: Month(
      text: '2월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    march: Month(
      text: '3월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    april: Month(
      text: '4월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    may: Month(
      text: '5월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    june: Month(
      text: '6월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    july: Month(
      text: '7월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    august: Month(
      text: '8월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    september: Month(
      text: '9월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    october: Month(
      text: '10월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    november: Month(
      text: '11월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    december: Month(
      text: '12월',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );

  // English
  static const MonthSettings english = MonthSettings(
    january: Month(
      text: 'January',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    february: Month(
      text: 'February',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    march: Month(
      text: 'March',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    april: Month(
      text: 'April',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    may: Month(
      text: 'May',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    june: Month(
      text: 'June',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    july: Month(
      text: 'July',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    august: Month(
      text: 'August',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    september: Month(
      text: 'September',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    october: Month(
      text: 'October',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    november: Month(
      text: 'November',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
    december: Month(
      text: 'December',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );
}

// month
class Month {
  final String text;
  final TextStyle style;

  const Month({
    required this.text,
    required this.style,
  });

  // copyWith
  Month copyWith({
    String? text,
    TextStyle? style,
  }) {
    return Month(
      text: text ?? this.text,
      style: style ?? this.style,
    );
  }

  @override
  String toString() {
    return 'Month{text: $text, style: $style}';
  }
}
