import 'package:flutter/material.dart';

import 'package:cool_datepicker/enums/range_type.dart';

class RangeDatepickerController {
  final DateTimeRange? selectedRange;

  RangeItemModel? _startItem;
  RangeItemModel? _endItem;

  RangeDatepickerController({this.selectedRange});

  RangeAnimationController? setRange(RangeItemModel rangeItem) {
    if (_startItem != null && _endItem != null) {
      final startItem = _startItem;
      final endItem = _endItem;
      _startItem = rangeItem;
      _endItem = null;
      return RangeAnimationController(
        forward: _startItem,
        reverse: [
          if (startItem != null && startItem != rangeItem) startItem,
          if (endItem != null) endItem
        ],
      );
    }

    if (_startItem == null) {
      _startItem = rangeItem;
      return RangeAnimationController(
        forward: _startItem,
        reverse: [],
      );
    }

    if (_startItem != null && rangeItem.date.isAfter(_startItem!.date)) {
      _endItem = rangeItem;
      return RangeAnimationController(
        forward: _endItem,
        reverse: [],
        selectedRange: RangeModel(start: _startItem!, end: _endItem!),
      );
    } else {
      if (_startItem == rangeItem) {
        _startItem = null;
        return RangeAnimationController(
          forward: null,
          reverse: [rangeItem],
        );
      } else {
        final startItem = _startItem;
        _startItem = rangeItem;
        return RangeAnimationController(
          forward: _startItem,
          reverse: [startItem!],
        );
      }
    }
  }
}

class RangeAnimationController {
  final RangeItemModel? forward;
  final List<RangeItemModel> reverse;
  final RangeModel? selectedRange;

  const RangeAnimationController(
      {required this.forward, required this.reverse, this.selectedRange});

  RangeAnimationController copyWith({
    RangeItemModel? forward,
    List<RangeItemModel>? reverse,
    RangeModel? selectedRange,
  }) {
    return RangeAnimationController(
      forward: forward ?? this.forward,
      reverse: reverse ?? this.reverse,
      selectedRange: selectedRange ?? this.selectedRange,
    );
  }

  @override
  String toString() =>
      'RangeAnimationController(forward: $forward, reverse: $reverse, selectedRange: $selectedRange)';
}

class RangeModel {
  final RangeItemModel start;
  final RangeItemModel end;

  const RangeModel({required this.start, required this.end});
}

class RangeItemModel {
  final DateTime date;
  final bool isDisabled;
  final int index;

  const RangeItemModel({
    required this.date,
    required this.isDisabled,
    required this.index,
  });

  RangeItemModel copyWith({
    DateTime? date,
    bool? isDisabled,
    int? index,
    RangeType? type,
  }) {
    return RangeItemModel(
      date: date ?? this.date,
      isDisabled: isDisabled ?? this.isDisabled,
      index: index ?? this.index,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeItemModel &&
        other.date == date &&
        other.isDisabled == isDisabled &&
        other.index == index;
  }

  @override
  int get hashCode {
    return date.hashCode ^ isDisabled.hashCode ^ index.hashCode;
  }

  @override
  String toString() {
    return 'RangeItemModel(date: $date, isDisabled: $isDisabled, index: $index)';
  }
}
