import 'package:cool_datepicker/widgets/month_view.dart';
import 'package:flutter/material.dart';

class YearView extends StatefulWidget {
  final int minYear;
  final int maxYear;
  final int year;
  final OnSelected onYearSelected;
  const YearView({
    Key? key,
    required this.year,
    this.minYear = 1900,
    this.maxYear = 2100,
    required this.onYearSelected,
  }) : super(key: key);

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  late ScrollController controller;
  double rowHeight = 75.0;

  @override
  void initState() {
    super.initState();

    int offsetIndex = (widget.year - widget.minYear) ~/ 3;

    double offset = offsetIndex * rowHeight;
    controller = ScrollController(initialScrollOffset: offset);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: controller,
        itemCount:
            (widget.maxYear - widget.minYear) ~/ 3 + 1, // 총 연도 수를 3으로 나눈 값
        itemBuilder: (context, index) {
          int year1 = widget.minYear + index * 3;
          int year2 = year1 + 1;
          int year3 = year1 + 2;
          return SizedBox(
            height: rowHeight, // 행의 높이
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () => widget.onYearSelected(year1),
                  child: Center(
                      child: Text('$year1', style: TextStyle(fontSize: 18))),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () => widget.onYearSelected(year2),
                  child: Center(
                      child: Text('$year2', style: TextStyle(fontSize: 18))),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () => widget.onYearSelected(year3),
                  child: Center(
                      child: Text('$year3', style: TextStyle(fontSize: 18))),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
