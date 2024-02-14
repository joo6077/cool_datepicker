import 'package:cool_datepicker/controllers/datepicker_single_controller.dart';
import 'package:cool_datepicker/library/utils/date_time_extension.dart';
import 'package:cool_datepicker/models/date_info_model.dart';
import 'package:cool_datepicker/widgets/animated_selected_item.dart';
import 'package:flutter/material.dart';

class CalendarSingleBody extends StatefulWidget {
  final DateTime selectedDate;
  final DatepickerSingleController datepickerController;

  const CalendarSingleBody({
    Key? key,
    required this.selectedDate,
    required this.datepickerController,
  }) : super(key: key);

  @override
  State<CalendarSingleBody> createState() => _CalendarSingleBodyState();
}

class _CalendarSingleBodyState extends State<CalendarSingleBody>
    with TickerProviderStateMixin {
  late final List<DatepickerDateItem?> _items;

  @override
  void initState() {
    super.initState();
    final currentMonthDays = widget.datepickerController.selectedYearMonthMap[
        DateTime(widget.selectedDate.year, widget.selectedDate.month)];
    _items = widget.datepickerController
        .initializeDate(
      date: widget.selectedDate,
      selectedDates: widget.datepickerController.selectedDates,
    )
        .map(
      (e) {
        if (e == null) {
          return null;
        }
        final isSelected = currentMonthDays
                ?.any((element) => element.date.isSameDay(e.date)) ??
            false;
        return DatepickerDateItem(
          controller: AnimationController(
            vsync: this,
            value: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
          ),
          date: e.date,
          index: e.index,
          isDisabled: e.isDisabled,
        );
      },
    ).toList();
  }

  @override
  void dispose() {
    for (var item in _items) {
      item?.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: _items.map((e) => _buildDay(e)).toList(),
    );
  }

  Widget _buildDay(DatepickerDateItem? item) {
    if (item == null) {
      return const SizedBox();
    }

    final day = item.date.day;
    return day > 0
        ? AnimatedSelectedItem(
            onTap: item.isDisabled
                ? null
                : () {
                    final removeItem =
                        widget.datepickerController.onSelected(item);
                    item.controller.forward();
                    if (removeItem != null) {
                      _items[removeItem.index]?.controller.reverse();
                    }
                  },
            controller: item.controller,
            selectedItem: Center(
              child: Container(
                width: 40,
                height: 40,
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

class DatepickerDateItem extends DateInfoModel {
  final AnimationController controller;

  DatepickerDateItem({
    required super.date,
    required super.index,
    required super.isDisabled,
    required this.controller,
  });
}
