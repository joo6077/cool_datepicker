library cool_datepicker;

import 'package:flutter/material.dart';
import 'package:cool_datepicker/views/calendar.dart';
import 'package:cool_datepicker/library/utils/extension_util.dart';

class CoolDatepicker extends StatefulWidget {
  // datepicker
  List<DateTime>? disabledList;
  List<Map<String, DateTime?>>? disabledRangeList;
  int? minYear;
  int? maxYear;
  late List<Map> years = [];
  Function onSelected;
  List<DateTime>? _selectedItems;
  Map<String, DateTime?>? selectedRangeItem;
  bool isRange;
  String format;
  int limitCount;
  dynamic defaultValue;
  List<String>? weekLabelList;
  List<String>? monthLabelList;
  late List weekLabelMapList;
  late List monthLabelMapList;
  bool isYearMonthDropdownReverse;
  int ? firstWeekDay;

  // color
  Color headerColor;
  Color arrowIconAreaColor;
  Color selectedCircleColor;
  Color selectedBetweenAreaColor;
  Color cancelFontColor;
  LinearGradient okButtonColor;
  Color bottomSelectedBorderColor;

  // label
  String cancelBtnLabel;
  String okBtnLabel;
  String placeholder;

  // bool isAnimation;
  bool isResultLabel;
  bool isResultIconLabelReverse;
  bool isDark;

  // size
  double resultWidth;
  double resultHeight;
  double iconSize;
  double calendarSize;

  // align
  Alignment resultAlign;

  // padding
  EdgeInsets resultPadding;

  // style
  late BoxDecoration resultBD;
  late TextStyle resultTS;
  late TextStyle placeholderTS;

  // gap
  double labelIconGap;

  CoolDatepicker({
    this.limitCount = 1,
    this.format = 'yyyy-mm-dd',
    this.iconSize = 25,
    this.calendarSize = 400,
    this.disabledList,
    this.disabledRangeList,
    this.minYear,
    this.maxYear,
    required this.onSelected,
    this.isRange = false,
    this.selectedRangeItem,
    resultIcon,
    placeholderTS,
    this.isResultIconLabelReverse = false,
    this.placeholder = '',
    this.resultWidth = 220,
    this.resultHeight = 50,
    this.resultAlign = Alignment.centerLeft,
    this.resultPadding = const EdgeInsets.only(left: 10, right: 10),
    resultBD,
    resultTS,
    this.labelIconGap = 10,
    // this.isAnimation = true,
    // this.isResultIconLabel = true,
    this.defaultValue,
    this.weekLabelList,
    this.monthLabelList,
    this.isYearMonthDropdownReverse = false,
    this.bottomSelectedBorderColor = const Color(0XFF6771e4),
    this.headerColor = const Color(0XFF6771e4),
    this.arrowIconAreaColor = const Color(0XFF4752e0),
    this.selectedCircleColor = const Color(0XFF6771e4),
    this.selectedBetweenAreaColor = const Color(0XFFe2e4fa),
    this.cancelFontColor = const Color(0XFF4a54c5),
    this.okButtonColor = const LinearGradient(colors: [
      Color(0XFF4a54c5),
      Color(0XFF6771e4), // headerColor
    ]),
    this.isDark = false,
    this.cancelBtnLabel = 'CANCEL',
    this.okBtnLabel = 'OK',
    this.isResultLabel = true,
    this.firstWeekDay = DateTime.sunday,
  }) {
    // disabledRangeList 체크
    if (disabledRangeList != null) {
      for (var rangeMap in disabledRangeList!) {
        assert((rangeMap['start'] != null) && (rangeMap['end'] != null),
            "both of start and end can't be null");
        assert(rangeMap['start']!.isBefore(rangeMap['end']!),
            'start DateTIme must be earlier than end DateTime');
        assert(!(rangeMap['start']!.compare(rangeMap['end']!)),
            "start and end can't be the same. Try to use in 'disabledList' option");
      }
    }
    // year dropdownList 셋팅
    minYear = minYear ?? (DateTime.now().year - 100);
    maxYear = maxYear ?? (DateTime.now().year + 100);
    assert((maxYear! > minYear!), 'maxYear > minYear');
    for (var i = maxYear; i! >= minYear!; i--) {
      years.add({'label': '$i', 'value': i});
    }

    assert(
        (format.contains('yyyy') &&
            format.contains('mm') &&
            format.contains('dd')),
        'you must include yyyy, dd, mm');

    assert(
    (firstWeekDay! >=1) && (firstWeekDay! <= 7),
    'firstWeekDay must be > 0 and <= 7. The code number is: '
        ' monday = 1, tuesday = 2 wednesday = 3, thursday = 4, friday = 5, saturday = 6, sunday = 7'
    );

    // weekLabelList setting
    weekLabelMapList = [
      {'label': weekLabelList?[0] ?? 'S', 'color': const Color(0XFFE70000)},
      {'label': weekLabelList?[1] ?? 'M', 'color': const Color(0XFF333333)},
      {'label': weekLabelList?[2] ?? 'T', 'color': const Color(0XFF333333)},
      {'label': weekLabelList?[3] ?? 'W', 'color': const Color(0XFF333333)},
      {'label': weekLabelList?[4] ?? 'T', 'color': const Color(0XFF333333)},
      {'label': weekLabelList?[5] ?? 'F', 'color': const Color(0XFF333333)},
      {'label': weekLabelList?[6] ?? 'S', 'color': const Color(0XFF22A2BF)}
    ];

    List sourceWeekLabels = List.from(weekLabelMapList);
    for(int i=0; i<sourceWeekLabels.length; i++){
      weekLabelMapList[i] = sourceWeekLabels[(i+firstWeekDay!)%7];
    }

    monthLabelMapList = [
      {'label': monthLabelList?[0] ?? '01', 'value': 1},
      {'label': monthLabelList?[1] ?? '02', 'value': 2},
      {'label': monthLabelList?[2] ?? '03', 'value': 3},
      {'label': monthLabelList?[3] ?? '04', 'value': 4},
      {'label': monthLabelList?[4] ?? '05', 'value': 5},
      {'label': monthLabelList?[5] ?? '06', 'value': 6},
      {'label': monthLabelList?[6] ?? '07', 'value': 7},
      {'label': monthLabelList?[7] ?? '08', 'value': 8},
      {'label': monthLabelList?[8] ?? '09', 'value': 9},
      {'label': monthLabelList?[9] ?? '10', 'value': 10},
      {'label': monthLabelList?[10] ?? '11', 'value': 11},
      {'label': monthLabelList?[11] ?? '12', 'value': 12},
    ];

    // box decoration 셋팅
    this.resultBD = resultBD ??
        BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        );
    this.resultTS = resultTS ??
        const TextStyle(
          fontSize: 20,
          color: Colors.black,
        );
    this.placeholderTS = placeholderTS ??
        TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 20);
    if (defaultValue != null) {
      if (isRange) {
        assert(defaultValue is Map<String, DateTime?>,
            'the range defaultValue must be type of Map<String, DateTime?>');
        assert(defaultValue['start'] != null,
            'the range defaultValue must include "start" key of Map');
        if (disabledList != null) {
          for (var j = 0; j < disabledList!.length; j++) {
            assert(!!isSameBtwDates(defaultValue!['start'], disabledList![j]),
                "the range defaultValue['start'] and the disabledList items can't be duplicated");
          }
          for (var j = 0; j < disabledList!.length; j++) {
            assert(!isSameBtwDates(defaultValue!['end'], disabledList![j]),
                "the range defaultValue['end'] and the disabledList items can't be duplicated");
          }
        }
        if (disabledRangeList != null) {
          for (var j = 0; j < disabledRangeList!.length; j++) {
            DateTime startDate = disabledRangeList![j]['start']!;
            DateTime endDate = disabledRangeList![j]['end']!;
            DateTime targetStartDate = defaultValue['start'];
            DateTime targetEndDate = defaultValue['end'];

            assert(
                !(startDate.checkAfter(target: targetStartDate) &&
                    endDate.checkBefore(target: targetStartDate)),
                "the defaultValue range start can't be ranged between disabledRangeList items");
            assert(
                !(startDate.checkAfter(target: targetEndDate) &&
                    endDate.checkBefore(target: targetEndDate)),
                "the defaultValue range end can't be ranged between disabledRangeList items");
          }
        }
      } else {
        assert(defaultValue is List<DateTime>,
            'the single defaultValue must be type of List<DateTime>');
        assert(!(defaultValue!.length > limitCount),
            'the number of the single defaultValue items must be less than limitCount');
        for (var i = 0; i < defaultValue.length; i++) {
          if (disabledList != null) {
            for (var j = 0; j < disabledList!.length; j++) {
              assert(!isSameBtwDates(defaultValue![i], disabledList![j]),
                  "the single defaultValue and the disabledList items can't be duplicated");
            }
          }
          if (disabledRangeList != null) {
            for (var j = 0; j < disabledRangeList!.length; j++) {
              DateTime startDate = disabledRangeList![j]['start']!;
              DateTime endDate = disabledRangeList![j]['end']!;
              DateTime targetDate = defaultValue[i];

              assert(
                  !(startDate.checkAfter(target: targetDate) &&
                      endDate.checkBefore(target: targetDate)),
                  "the defaultValue can't be ranged between disabledRangeList items");
            }
          }
          for (var j = 0; j < defaultValue.length; j++) {
            if (i != j) {
              assert(!isSameBtwDates(defaultValue![i], defaultValue[j]),
                  "the signle defaultValue items can't be duplicated");
            }
          }
        }
      }
    }
  }

  bool isSameBtwDates(DateTime target1, DateTime target2) {
    return (target1.year == target2.year &&
        target1.month == target2.month &&
        target1.day == target2.day);
  }

  @override
  _CoolDatepickerState createState() => _CoolDatepickerState();
}

class _CoolDatepickerState extends State<CoolDatepicker>
    with TickerProviderStateMixin {
  GlobalKey inputKey = GlobalKey();
  GlobalKey datePickerIconKey = GlobalKey();
  GlobalKey<CalendarState> datePickerOverlayKey = GlobalKey();
  Offset triangleOffset = const Offset(0, 0);
  late OverlayEntry _overlayEntry;
  // AnimationUtil au = AnimationUtil();
  bool isOpen = false;
  String rangeLabel = '';
  String selectedLabel = '';
  double textBoxWidth = 0;

  openCalendar() {
    setState(() {
      isOpen = true;
    });
    _overlayEntry = _createOverlayEntry();
    Overlay.of(datePickerIconKey.currentContext!)!.insert(_overlayEntry);
  }

  closeCalendar() async {
    await datePickerOverlayKey.currentState!.animationController.reverse();
    setState(() {
      isOpen = false;
    });
    _overlayEntry.remove();
  }

  OverlayEntry _createOverlayEntry() {
    dynamic datePickerIconObj =
        datePickerIconKey.currentContext!.findRenderObject();
    Offset datePickerIconPosition =
        datePickerIconObj!.localToGlobal(Offset.zero);

    return OverlayEntry(
        opaque: false,
        maintainState: true,
        builder: (BuildContext context) {
          return Calendar(
            parentBuildContext: context,
            key: datePickerOverlayKey,
            disabledList: widget.disabledList,
            disabledRangeList: widget.disabledRangeList,
            isYearMonthDropdownReverse: widget.isYearMonthDropdownReverse,
            years: widget.years,
            onSelected: widget.onSelected,
            weekLabelList: widget.weekLabelMapList,
            monthLabelList: widget.monthLabelMapList,
            firstWeekDay: widget.firstWeekDay!,
            getSelectedItems: (selectedItems) {
              if (selectedItems is Map) {
                setState(() {
                  widget.selectedRangeItem =
                      selectedItems.cast<String, DateTime?>();
                  rangeLabel = selectedRangeString();
                });
              }
              if (selectedItems is List) {
                setState(() {
                  widget._selectedItems = selectedItems.cast<DateTime>();
                  selectedLabel = selectedDatesToString();
                });
              }
            },
            selectedItems: widget._selectedItems,
            selectedRangeItem: widget.selectedRangeItem,
            isRange: widget.isRange,
            datePickerIconPosition: datePickerIconPosition,
            calendarSize: widget.calendarSize,
            iconSize: widget.iconSize,
            fullSize: MediaQuery.of(context).size,
            closeCalendar: () {
              closeCalendar();
            },
            limitCount: widget.limitCount,
            format: widget.format,
            headerColor: widget.headerColor,
            arrowIconAreaColor: widget.arrowIconAreaColor,
            selectedCircleColor: widget.selectedCircleColor,
            selectedBetweenAreaColor: widget.selectedBetweenAreaColor,
            cancelFontColor: widget.cancelFontColor,
            okButtonColor: widget.okButtonColor,
            isDark: widget.isDark,
            cancelBtnLabel: widget.cancelBtnLabel,
            okBtnLabel: widget.okBtnLabel,
            bottomSelectedBorderColor: widget.bottomSelectedBorderColor,
          );
        });
  }

  @override
  void initState() {
    // placeholder 셋팅
    setDefaultValue();
    super.initState();
  }

  void setDefaultValue() {
    setState(() {
      if (widget.defaultValue != null) {
        if (widget.isRange) {
          widget.selectedRangeItem = widget.defaultValue;
          rangeLabel = selectedRangeString();
        } else {
          widget._selectedItems = widget.defaultValue;
          selectedLabel = selectedDatesToString();
        }
      }
    });
  }

  String setFormat({int? yyyy, int? mm, int? dd}) {
    return widget.format
        .replaceAll('yyyy', yyyy.toString())
        .replaceAll('mm',
            mm.toString().length == 1 ? '0' + mm.toString() : mm.toString())
        .replaceAll('dd',
            dd.toString().length == 1 ? '0' + dd.toString() : dd.toString());
  }

  String dateTimeToFormat({DateTime? target}) {
    return setFormat(
      yyyy: target!.year,
      mm: target.month,
      dd: target.day,
    );
  }

  String selectedRangeString() {
    String result = '';
    if (widget.selectedRangeItem!['start'] != null) {
      result +=
          dateTimeToFormat(target: widget.selectedRangeItem!['start']) + ' ~ ';
    }
    if (widget.selectedRangeItem!['end'] != null) {
      result += dateTimeToFormat(target: widget.selectedRangeItem!['end']);
    }
    return result;
  }

  String selectedDatesToString() {
    String result = '';
    if (widget._selectedItems!.isNotEmpty) {
      for (var i = 0; i < widget._selectedItems!.length; i++) {
        if (i == widget._selectedItems!.length - 1) {
          result += dateTimeToFormat(target: widget._selectedItems![i]);
        } else {
          result += dateTimeToFormat(target: widget._selectedItems![i]) + ', ';
        }
      }
    } else {
      result = '';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          await closeCalendar();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          openCalendar();
        },
        child: Stack(
          children: [
            Container(
              key: inputKey,
              width: widget.resultWidth,
              height: widget.resultHeight,
              padding: widget.resultPadding,
              decoration: widget.resultBD,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    if (widget.isResultLabel)
                      if ((widget._selectedItems == null ||
                              widget._selectedItems!.isEmpty) &&
                          widget.selectedRangeItem == null)
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.placeholder,
                            style: widget.placeholderTS,
                          ),
                        )),
                    if (widget.isResultLabel)
                      if (widget.isRange && widget.selectedRangeItem != null)
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            rangeLabel,
                            style: widget.resultTS,
                          ),
                        )),
                    if (widget.isResultLabel)
                      if (!widget.isRange &&
                          (widget._selectedItems != null &&
                              widget._selectedItems!.isNotEmpty))
                        Expanded(
                            child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            selectedLabel,
                            style: widget.resultTS,
                          ),
                        )),
                    SizedBox(
                      width: widget.labelIconGap,
                    ),
                    Stack(
                      children: [
                        Opacity(
                          opacity: isOpen ? 0 : 1,
                          child: SizedBox(
                            width: widget.iconSize,
                            child: Calendar(
                              key: datePickerIconKey,
                              firstWeekDay: widget.firstWeekDay!,
                              iconSize: widget.iconSize,
                              calendarSize: widget.calendarSize,
                              isYearMonthDropdownReverse:
                                  widget.isYearMonthDropdownReverse,
                              weekLabelList: widget.weekLabelMapList,
                              monthLabelList: widget.monthLabelMapList,
                              isIcon: true,
                              years: widget.years,
                              onSelected: widget.onSelected,
                              getSelectedItems: (_) {},
                              isRange: widget.isRange,
                              fullSize: MediaQuery.of(context).size,
                              closeCalendar: (_) {},
                              selectedItems: widget._selectedItems,
                              selectedRangeItem: widget.selectedRangeItem,
                              parentBuildContext: context,
                              limitCount: widget.limitCount,
                              format: widget.format,
                              headerColor: widget.headerColor,
                              arrowIconAreaColor: widget.arrowIconAreaColor,
                              selectedCircleColor: widget.selectedCircleColor,
                              selectedBetweenAreaColor:
                                  widget.selectedBetweenAreaColor,
                              cancelFontColor: widget.cancelFontColor,
                              okButtonColor: widget.okButtonColor,
                              isDark: widget.isDark,
                              cancelBtnLabel: widget.cancelBtnLabel,
                              okBtnLabel: widget.okBtnLabel,
                              bottomSelectedBorderColor:
                                  widget.bottomSelectedBorderColor,
                            ),
                          ),
                        ),
                        Container(
                            width: widget.iconSize,
                            height: widget.iconSize,
                            color: Colors.transparent)
                      ],
                    ),
                  ].isReverse(widget.isResultIconLabelReverse)),
            ),
          ],
        ),
      ),
    );
  }
}
