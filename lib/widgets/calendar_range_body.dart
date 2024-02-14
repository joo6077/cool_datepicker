import 'package:cool_datepicker/controllers/range_datepicker_controller.dart';
import 'package:cool_datepicker/enums/range_type.dart';
import 'package:cool_datepicker/library/utils/date_time_extension.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/models/multiple_datepicker_options.dart';
import 'package:cool_datepicker/widgets/animated_range_selected_item.dart';
import 'package:flutter/material.dart';

class CalendarRangeBody extends StatefulWidget {
  final WeekSettings weekSettings;
  final DateTime selectedDate;
  final RangeDatepickerController datepickerController;
  final DatepickerOptions? options;

  const CalendarRangeBody({
    Key? key,
    required this.weekSettings,
    required this.selectedDate,
    required this.datepickerController,
    required this.options,
  }) : super(key: key);

  @override
  State<CalendarRangeBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarRangeBody>
    with TickerProviderStateMixin {
  late final List<RangeDateModel?> _items;

  late DateTimeRange? _selectedRange =
      widget.datepickerController.startDate != null &&
              widget.datepickerController.endDate != null
          ? DateTimeRange(
              start: widget.datepickerController.startDate!,
              end: widget.datepickerController.endDate!,
            )
          : null;

  @override
  void initState() {
    super.initState();
    final startDate = widget.datepickerController.startDate;
    final endDate = widget.datepickerController.endDate;

    _items = widget.options?.initializeSingle(
          date: widget.selectedDate,
          firstDayOfWeek: widget.weekSettings.firstDayOfWeek,
          selectedDates: [],
        ).map(
          (e) {
            if (e == null) {
              return null;
            }

            final isStartDate = startDate?.isSameDay(e.date) ?? false;
            final isEndDate = endDate?.isSameDay(e.date) ?? false;
            final isBetween = startDate != null &&
                endDate != null &&
                e.date.isBetween(startDate, endDate);

            return RangeDateModel(
              dateController: AnimationController(
                vsync: this,
                value: isStartDate || isEndDate ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
              ),
              date: e.date,
              index: e.index,
              isDisabled: e.isDisabled,
              rangeController: AnimationController(
                vsync: this,
                value: isBetween || isStartDate || isEndDate ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 50),
              ),
            );
          },
        ).toList() ??
        [];
  }

  @override
  void dispose() {
    for (var item in _items) {
      item?.dateController.dispose();
      item?.rangeController.dispose();
    }
    super.dispose();
  }

  void _controlAnimation(RangeDateModel item) async {
    final result = widget.datepickerController.setRange(item);

    if (result != null) {
      if (result.reverse.isNotEmpty) {
        /// Animate the previous selected date reverse
        for (var reverseItem in result.reverse) {
          if (reverseItem.date.isCurrentMonth(widget.selectedDate)) {
            _items[reverseItem.index]?.dateController.reverse();
          }
        }
      }

      /// Animate the selected date forward
      if (result.forward != null) {
        if (result.forward!.date.isCurrentMonth(widget.selectedDate)) {
          _items[result.forward!.index]?.dateController.forward();
        }
      }

      /// Determine the range type(start, end, range)
      /// to draw the background color of the selected date
      setState(() {
        if (result.selectedRange != null) {
          _selectedRange = DateTimeRange(
              start: result.selectedRange!.start.date,
              end: result.selectedRange!.end.date);
        }
      });

      /// Animate the range background color
      if (result.selectedRange != null) {
        /// if start date is previous month, animate between date and end of the month
        /// check previous month
        if (result.selectedRange!.start.date
            .isBefore(widget.selectedDate.copyWith(day: 1))) {
          for (var i = 0; i < result.selectedRange!.end.index + 1; i++) {
            final item = _items[i];
            if (item != null) {
              await item.rangeController.forward();
            }
          }
        } else {
          /// Animate the range background color
          for (var i = result.selectedRange!.start.index;
              i < result.selectedRange!.end.index + 1;
              i++) {
            final item = _items[i];
            if (item != null) {
              await item.rangeController.forward();
            }
          }
        }
      } else {
        /// Reset the range background color
        for (var i = 0; i < _items.length; i++) {
          final item = _items[i];
          if (item != null) {
            item.rangeController.reset();
          }
        }
      }
    }
  }

  RangeType _getRangeType(DateTime date) {
    if (_selectedRange == null) {
      return RangeType.range;
    }

    if (date.isSameDay(_selectedRange!.start)) {
      return RangeType.start;
    }

    if (date.isSameDay(_selectedRange!.end)) {
      return RangeType.end;
    }

    return RangeType.range;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: _items.map((e) => _buildDay(e)).toList(),
    );
  }

  Widget _buildDay(RangeDateModel? item) {
    if (item == null) {
      return const SizedBox();
    }

    final day = item.date.day;
    return day > 0
        ? AnimatedRangeSelectedItem(
            rangeType: _getRangeType(item.date),
            backgroundWidget: Container(
              width: double.infinity,
              height: 40,
              color: const Color(0XFFe2e4fa),
            ),
            onTap: item.isDisabled ? null : () => _controlAnimation(item),
            dateController: item.dateController,
            rangeController: item.rangeController,
            selectedItem: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0XFFe2e4fa),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0XFF6771e4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            item: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: item.isDisabled ? Colors.grey : Colors.black,
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class RangeDateModel extends RangeItemModel {
  final AnimationController dateController;
  final AnimationController rangeController;

  RangeDateModel({
    required super.date,
    required super.index,
    required super.isDisabled,
    required this.dateController,
    required this.rangeController,
  });
}
