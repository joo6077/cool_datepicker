import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  final Month month;
  final int year;
  final VoidCallback onMonthTap, onYearTap;
  const CalendarHeader({
    Key? key,
    required this.month,
    required this.year,
    required this.onMonthTap,
    required this.onYearTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0XFF6771e4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onMonthTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    month.text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              GestureDetector(
                onTap: onYearTap,
                child: Text(
                  year.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
