import 'package:cool_datepicker/models/day_of_week.dart';
import 'package:cool_datepicker/widgets/calendar_header.dart';
import 'package:flutter/material.dart';

class NewCoolDatepicker extends StatelessWidget {
  const NewCoolDatepicker({Key? key}) : super(key: key);

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
          PageView.builder(itemBuilder: (_, index) {
            return Column(
              children: [
                CalendarHeader(),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 7,
                    children: List.generate(42, (index) {
                      return Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              shape: BoxShape.circle),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),
          Positioned(
            top: 0,
            height: 50,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            height: 50,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              // decoration: const BoxDecoration(
              //   color: Color(0XFF6771e4),
              // ),
              child: Row(
                  children: DayOfWeek.korean.list.map((day) {
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
        ],
      ),
    );
  }
}
