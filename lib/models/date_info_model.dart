class DateInfoModel {
  final DateTime date;
  final int index;
  final bool isDisabled;

  const DateInfoModel({
    required this.date,
    required this.index,
    this.isDisabled = false,
  });

  DateInfoModel copyWith({
    DateTime? date,
    int? index,
    bool? isDisabled,
  }) {
    return DateInfoModel(
      date: date ?? this.date,
      index: index ?? this.index,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }

  // toString
  @override
  String toString() {
    return 'DatepickerMultipleItem(date: $date, index: $index, isDisabled: $isDisabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DateInfoModel &&
        other.date == date &&
        other.index == index &&
        other.isDisabled == isDisabled;
  }

  @override
  int get hashCode => date.hashCode ^ index.hashCode;
}
