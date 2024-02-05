import 'package:cool_datepicker/models/multiple_datepicker_options.dart';
import 'package:flutter/material.dart';

import 'package:cool_datepicker/controllers/datepicker_controller.dart';
import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/widgets/animated_clip_rect.dart';
import 'package:cool_datepicker/widgets/calendar_body.dart';
import 'package:cool_datepicker/widgets/calendar_header.dart';
import 'package:cool_datepicker/widgets/month_view.dart';
import 'package:cool_datepicker/widgets/year_view.dart';

class NewCoolDatepicker extends StatelessWidget {
  final WeekSettings weekSettings;
  final MonthSettings monthSettings;
  final DatepickerOptions? options;

  const NewCoolDatepicker._({
    Key? key,
    required this.weekSettings,
    required this.monthSettings,
    required this.options,
  }) : super(key: key);

  // factory multi
  factory NewCoolDatepicker.multiple({
    required WeekSettings weekSettings,
    required MonthSettings monthSettings,
    DatepickerOptions? options,
  }) {
    return NewCoolDatepicker._(
      weekSettings: weekSettings,
      monthSettings: monthSettings,
      options: options,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _NewCoolDatepicker(
        weekSettings: weekSettings,
        monthSettings: monthSettings,
        options: options);
  }
}

class _NewCoolDatepicker extends StatefulWidget {
  final WeekSettings weekSettings;
  final MonthSettings monthSettings;
  final DatepickerOptions? options;
  const _NewCoolDatepicker({
    Key? key,
    required this.weekSettings,
    required this.monthSettings,
    required this.options,
  }) : super(key: key);

  @override
  State<_NewCoolDatepicker> createState() => _NewCoolDatepickerState();
}

class _NewCoolDatepickerState extends State<_NewCoolDatepicker> {
  late final PageController _pageController;

  final _datepickerController = DatepickerController();

  bool _isMonthOpened = false;
  bool _isYearOpened = false;

  @override
  void initState() {
    DateTime today = DateTime.now();
    int initialPage = _setPage(today);
    _pageController = PageController(initialPage: initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 450,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemBuilder: (_, index) {
              final date = _getDate(index);
              final month = date.month;
              final year = date.year;
              return Column(
                children: [
                  CalendarHeader(
                    onMonthTap: _onMonthTap,
                    onYearTap: _onYearTap,
                    month: widget.monthSettings.list[month - 1],
                    year: year,
                  ),
                  Expanded(
                      child: CalendarBody(
                    datepickerController: _datepickerController,
                    weekSettings: widget.weekSettings,
                    selectedDate: date,
                    options: widget.options,
                  )),
                ],
              );
            },
          ),
          Positioned(
            top: 0,
            height: 50,
            left: 0,
            child: IconButton(
              onPressed: _onPreviousMonth,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 0,
            height: 50,
            right: 0,
            child: IconButton(
              onPressed: _onNextMonth,
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 50,
            height: 50,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 50,
              child: Row(
                  children: widget.weekSettings.dayOfWeekList.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day.text,
                      style: day.style,
                    ),
                  ),
                );
              }).toList()),
            ),
          ),
          Positioned.fill(
            top: 50,
            child: Align(
              alignment: Alignment.topLeft,
              child: AnimatedClipRect(
                open: _isMonthOpened,
                child: MonthView(
                    monthSettings: widget.monthSettings,
                    onSelected: _onMonthSelected),
              ),
            ),
          ),
          Positioned.fill(
            top: 50,
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedClipRect(
                open: _isYearOpened,
                child: YearView(year: 2024, onYearSelected: _onYearSelected),
              ),
            ),
          )
        ],
      ),
    );
  }

  int _setPage(DateTime date) {
    return (date.year * 12 + date.month) - (2000 * 12);
  }

  DateTime _getDate(int page) {
    int year = (page ~/ 12) + 2000;
    int month = page % 12;
    return DateTime(year, month);
  }

  void _onMonthTap() {
    setState(() {
      _isYearOpened = false;
      _isMonthOpened = !_isMonthOpened;
    });
  }

  void _onYearTap() {
    setState(() {
      _isMonthOpened = false;
      _isYearOpened = !_isYearOpened;
    });
  }

  void _onMonthSelected(int index) {
    setState(() {
      _isMonthOpened = false;
    });
    final currentDate = _getDate(_pageController.page!.toInt());
    _pageController.animateToPage(
      _setPage(DateTime(currentDate.year, index + 1)),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onYearSelected(int value) {
    setState(() {
      _isYearOpened = false;
    });
    final currentDate = _getDate(_pageController.page!.toInt());
    _pageController.animateToPage(
      _setPage(DateTime(value, currentDate.month)),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPreviousMonth() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onNextMonth() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
