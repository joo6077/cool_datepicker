import 'package:cool_datepicker/models/date_calculator.dart';
import 'package:cool_datepicker/widgets/animated_clip_rect.dart';
import 'package:cool_datepicker/widgets/month_view.dart';
import 'package:flutter/material.dart';

import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/widgets/calendar_header.dart';

class NewCoolDatepicker extends StatefulWidget {
  final WeekSettings weekSettings;
  final MonthSettings monthSettings;
  const NewCoolDatepicker({
    Key? key,
    required this.weekSettings,
    required this.monthSettings,
  }) : super(key: key);

  @override
  State<NewCoolDatepicker> createState() => _NewCoolDatepickerState();
}

class _NewCoolDatepickerState extends State<NewCoolDatepicker> {
  late final PageController _pageController;

  bool _isMonthOpened = false;

  @override
  void initState() {
    DateTime today = DateTime.now();
    int initialPage = (today.year * 12 + today.month) - (2000 * 12);
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
              final year = (index ~/ 12) + 2000;
              final month = index % 12;
              // -1 because month is 1-12, but list is 0-11 if it's negative, it will be 11
              var monthIndex = month - 1;
              if (monthIndex < 0) {
                monthIndex = 11;
              }
              return Column(
                children: [
                  CalendarHeader(
                    onMonthTap: () {
                      setState(() {
                        _isMonthOpened = !_isMonthOpened;
                      });
                    },
                    onYearTap: () {},
                    month: widget.monthSettings.list[monthIndex],
                    year: year,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 7,
                      children: DateCalculator.generateMonthDays(
                        year,
                        month,
                        widget.weekSettings.firstDayOfWeek,
                      ).map((day) {
                        return day > 0
                            ? Center(
                                child: Text(day.toString()),
                              )
                            : const SizedBox();
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            top: 0,
            height: 50,
            left: 0,
            child: IconButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
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
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
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
              // decoration: const BoxDecoration(
              //   color: Color(0XFF6771e4),
              // ),
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
          AnimatedClipRect(
            open: _isMonthOpened,
            child: MonthView(
              monthSettings: widget.monthSettings,
              onSelected: (index) {
                setState(() {
                  _isMonthOpened = false;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
