import 'package:flutter/material.dart';

import 'package:cool_datepicker/models/day_of_week.dart';

typedef OnMonthSelected = void Function(int month);

class MonthView extends StatelessWidget {
  final OnMonthSelected onSelected;
  final MonthSettings monthSettings;

  const MonthView({
    Key? key,
    required this.onSelected,
    required this.monthSettings,
  }) : super(key: key);

  Widget _buildRow(int rowIndex) {
    return Expanded(
      child: Row(
        children: List.generate(3, (colIndex) {
          int index = rowIndex * 3 + colIndex;
          return Expanded(
            child: monthWidget(monthSettings.list[index], index),
          );
        }),
      ),
    );
  }

  Widget monthWidget(Month month, int index) {
    return GestureDetector(
      onTap: () => onSelected(index),
      child: Center(
        child: Text(month.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: List.generate(4, (index) => _buildRow(index))),
    );
  }
}
