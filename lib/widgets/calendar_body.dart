import 'package:cool_datepicker/controllers/datepicker_controller.dart';
import 'package:cool_datepicker/library/utils/extension_util.dart';
import 'package:cool_datepicker/models/date_calculator.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/widgets/animated_clip_rect.dart';
import 'package:cool_datepicker/widgets/animated_selected_item.dart';
import 'package:flutter/material.dart';

class CalendarBody extends StatefulWidget {
  final WeekSettings weekSettings;
  final DateTime selectedDate;
  final DatepickerController datepickerController;

  const CalendarBody({
    Key? key,
    required this.weekSettings,
    required this.selectedDate,
    required this.datepickerController,
  }) : super(key: key);

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody>
    with TickerProviderStateMixin {
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    for (int i = 0; i < 42; i++) {
      _animationControllers.add(AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ));
    }
    _setInitialSelectedDate();
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < 42; i++) {
      _animationControllers[i].dispose();
    }
    super.dispose();
  }

  void _setInitialSelectedDate() {
    if (widget.datepickerController.selectedDates.isNotEmpty) {
      if (widget.datepickerController.selectedDates
          .containsKey(widget.selectedDate)) {
        for (var element in widget
            .datepickerController.selectedDates[widget.selectedDate]!) {
          _animationControllers[element.index].forward(from: 1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      children: DateCalculator.generateMonthDays(
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.weekSettings.firstDayOfWeek,
      ).mapIndexed((day, index) {
        return day > 0
            ? AnimatedSelectedItem(
                onTap: () {
                  widget.datepickerController.addSelectedDate(
                    widget.selectedDate,
                    day,
                    index,
                    _animationControllers[index],
                  );
                },
                controller: _animationControllers[index],
                selectedItem: Center(
                  child: Container(
                    width: 45,
                    height: 45,
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
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ))
            : const SizedBox();
      }).toList(),
    );
  }
}
