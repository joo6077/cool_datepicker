import 'package:cool_datepicker/controllers/datepicker_range_controller.dart';
import 'package:cool_datepicker/controllers/datepicker_single_controller.dart';
import 'package:flutter/material.dart';
import 'package:cool_datepicker/new_cool_datepicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFF6771e4),
            title: const Text('Cool Picker',
                style: TextStyle(color: Colors.white)),
          ),
          body: ListView(
            children: [
              Center(
                child: NewCoolDatepicker.single(
                  controller: DatepickerSingleController(
                    selectedDates: [
                      DateTime(2024, 2, 22),
                      DateTime(2024, 2, 12),
                      DateTime(2024, 1, 1)
                    ],
                    disabledList: [
                      DateTime(2024, 2, 22),
                      DateTime(2024, 2, 12)
                    ],
                    disabledRangeList: [
                      DateTimeRange(
                        start: DateTime(2024, 1, 1),
                        end: DateTime(2024, 1, 13),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
