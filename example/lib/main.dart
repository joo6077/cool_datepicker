import 'package:flutter/material.dart';
import 'package:cool_datepicker/cool_datepicker.dart';

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
            title: const Text('Cool Datepicker'),
          ),
          body: ListView(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.transparent,
              ),
              Center(
                  child: CoolDatepicker(
                onSelected: (selectedDates) {},
                // disabledList: [DateTime(2021, 10, 22), DateTime(2021, 10, 12)],
                disabledRangeList: [
                  {
                    'start': DateTime(2021, 11, 1),
                    'end': DateTime(2021, 11, 13)
                  },
                ],
                maxYear: 2100,
                minYear: 1900,
                calendarSize: 350,
                isRange: true,
                limitCount: 3,
                format: 'mm/dd/yyyy',
                // defaultValue: {
                //   'start': DateTime(2020, 9, 25),
                //   'end': DateTime(2021, 11, 24)
                // },
                // placeholder: '11/13/2021 ~ 11/14/',
                monthLabelList: const [
                  'January',
                  'February',
                  'March',
                  'April',
                  'May',
                  'June',
                  'July',
                  'August',
                  'September',
                  'October',
                  'November',
                  'December',
                ],
                isYearMonthDropdownReverse: true,
                isResultLabel: true,
              )),
              Container(
                width: 200,
                height: 600,
                color: Colors.transparent,
              ),
              Center(
                child: CoolDatepicker(
                  onSelected: (_) {},
                  weekLabelList: const ['일', '월', '화', '수', '목', '금', '토'],
                  calendarSize: 350,
                  monthLabelList: const [
                    '1월',
                    '2월',
                    '3월',
                    '4월',
                    '5월',
                    '6월',
                    '7월',
                    '8월',
                    '9월',
                    '10월',
                    '11월',
                    '12월',
                  ],
                  isRange: false,
                  headerColor: const Color(0xffea0f16),
                  selectedCircleColor: const Color(0xffea0f16),
                  arrowIconAreaColor: const Color(0xffc80d13),
                  selectedBetweenAreaColor: const Color(0xffea0f16),
                  cancelFontColor: const Color(0xffea0f16),
                  okButtonColor: const LinearGradient(
                      colors: [Color(0xffc80d10), Color(0xffea0f16)]),
                  bottomSelectedBorderColor: const Color(0xffea0f16),
                  isDark: true,
                  cancelBtnLabel: '취소',
                  format: 'yyyy년 mm월 dd일',
                  iconSize: 0.000001,
                  isResultIconLabelReverse: true,
                  okBtnLabel: '확인',
                  labelIconGap: 0,
                ),
              ),
            ],
          )),
    );
  }
}
