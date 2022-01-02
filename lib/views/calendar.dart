import 'dart:ui';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:cool_datepicker/enums/SelectType.dart';
import 'package:cool_datepicker/library/cool_dropdown.dart';
import 'package:cool_datepicker/models/calendar_info.dart';
import 'package:cool_datepicker/models/date_info.dart';
import 'package:cool_datepicker/models/dates_range.dart';
import 'package:cool_datepicker/library/utils/extension_util.dart';

class Calendar extends StatefulWidget {
  // datepicker
  List<DateTime>? disabledList;
  List<Map<String, DateTime?>>? disabledRangeList;
  List<Map> years;
  Function onSelected;
  Function getSelectedItems;
  Offset? datePickerIconPosition;
  Size fullSize;
  Function closeCalendar;
  BuildContext parentBuildContext;
  int limitCount;
  List weekLabelList;
  List monthLabelList;
  late double maxMonthDropdownWidth;
  bool isYearMonthDropdownReverse;
  int firstWeekDay;

  Color headerColor;
  Color arrowIconAreaColor;
  Color selectedCircleColor;
  Color selectedBetweenAreaColor;
  Color cancelFontColor;
  LinearGradient okButtonColor;
  Color bottomSelectedBorderColor;
  bool isDark;

  String format;
  List<DateTime>? selectedItems;
  Map<String, DateTime?>? selectedRangeItem;

  DatesRange datesRange = DatesRange();
  bool isRange;
  bool isIcon;
  double iconSize;
  double calendarSize;

  String cancelBtnLabel;
  String okBtnLabel;

  Key? key;

  Calendar({
    required this.limitCount,
    required this.parentBuildContext,
    required this.closeCalendar,
    required this.fullSize,
    this.isIcon = false,
    required this.iconSize,
    required this.calendarSize,
    this.datePickerIconPosition,
    required this.format,
    required this.isRange,
    this.disabledList,
    this.disabledRangeList,
    required this.years,
    required this.onSelected,
    required this.getSelectedItems,
    this.selectedItems = const [],
    this.selectedRangeItem,
    required this.weekLabelList,
    required this.monthLabelList,
    this.key,
    required this.isYearMonthDropdownReverse,
    required this.firstWeekDay,
    required this.headerColor,
    required this.arrowIconAreaColor,
    required this.selectedCircleColor,
    required this.selectedBetweenAreaColor,
    required this.cancelFontColor,
    required this.okButtonColor,
    required this.bottomSelectedBorderColor,
    required this.isDark,
    required this.cancelBtnLabel,
    required this.okBtnLabel,
  }) {
    List<double> monthLabelWidthList = [];
    for (var element in monthLabelList) {
      monthLabelWidthList.add(element['label']
          .toString()
          .getTextWidth(
              TextStyle(
                  fontSize: datePickerIconPosition != null
                      ? calendarSize * 0.04
                      : iconSize * 0.04,
                  fontWeight: FontWeight.bold),
              parentBuildContext)
          .width);
    }
    maxMonthDropdownWidth = monthLabelWidthList.reduce(max);
  }
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> with TickerProviderStateMixin {
  late Map yearValue;
  late Map monthValue;
  late CalendarInfo calendarInfo;
  GlobalKey<CoolDropdownState> yearDropdown = GlobalKey();
  GlobalKey<CoolDropdownState> monthDropdown = GlobalKey();
  GlobalKey<AnimatedListState> bottomListKey = GlobalKey();
  late AnimationController animationController;
  late AnimationController paddingController;
  late AnimationController startController;
  List<AnimationController> betweenControllerList = [];
  late AnimationController endController;
  late AnimationController bottomRangeBtnCtrl;
  late AnimationController bottomBorderCtrl;
  late AnimationController bottomBorderExpandCtrl;
  Animation<double>? animationCalendarTop;
  Animation<double>? animationCalendarLeft;
  Animation<double>? animationScale;
  Animation<double>? animationPadding;
  Animation<double>? animationBGBlur;
  Animation<Color?>? animationBGColor;
  late Animation<double> animationBorderExpand;
  late Animation<double> nullAnimation;
  bool isRight = false;
  double bottomRightSizedWidth = 0;
  late double bottomRangeBorderWidth;
  late double bottomRangeBorderExpandWidth;
  late double bottomRangeBorderHeight;
  List<DateTime>? bottomSelectedItems = [];
  String startDateStr = '';
  String endDateStr = '';

  late List<DateTime>? selectedItems;
  late Map<String, DateTime?>? selectedRangeItem;
  DatesRange datesRange = DatesRange();
  late List<DateTime?> selectedItemsHistory;

  @override
  void initState() {
    // not english
    String trimFormat = widget.format
        .replaceAll('yyyy', '')
        .replaceAll('mm', '')
        .replaceAll('dd', '')
        .replaceAll(' ', '');
    List<String> stringList = trimFormat.split('');
    final validCharacter = RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+$');
    int matchedIndexCount = stringList
        .where((element) => !validCharacter.hasMatch(element))
        .toList()
        .length;

    Size formatTextWidth = widget.format.getTextWidth(
        TextStyle(
            fontSize: widget.datePickerIconPosition != null
                ? widget.calendarSize * 0.04
                : widget.iconSize * 0.04,
            fontWeight: FontWeight.bold),
        widget.parentBuildContext);
    double eachScreenWidth = widget.datePickerIconPosition != null
        ? widget.calendarSize
        : widget.iconSize;
    double getWaveWidth = '~'
        .getTextWidth(
            TextStyle(
                fontSize: widget.datePickerIconPosition != null
                    ? widget.calendarSize * 0.04
                    : widget.iconSize * 0.04,
                fontWeight: FontWeight.bold),
            widget.parentBuildContext)
        .width;
    bottomRangeBorderWidth = formatTextWidth.width +
        getWaveWidth +
        (widget.datePickerIconPosition != null
            ? ((widget.calendarSize * 0.03) -
                (widget.calendarSize * 0.005 * matchedIndexCount))
            : widget.iconSize * 0.03) +
        (widget.datePickerIconPosition != null
            ? widget.calendarSize * 0.015
            : widget.iconSize * 0.015);
    bottomRangeBorderExpandWidth = getWaveWidth +
        formatTextWidth.width * 2 -
        (widget.datePickerIconPosition != null
            ? (widget.calendarSize * 0.01 * matchedIndexCount)
            : (widget.iconSize * 0.01 * matchedIndexCount));
    bottomRangeBorderHeight =
        formatTextWidth.height + (0.015 * eachScreenWidth * 2);

    // 초기값 셋팅
    selectedItems = widget.selectedItems ?? [];
    datesRange.start = widget.selectedRangeItem?['start'];
    datesRange.end = widget.selectedRangeItem?['end'];
    selectedItemsHistory =
        widget.selectedItems != null ? [...widget.selectedItems!] : [];

    yearValue = findValue(list: widget.years, value: DateTime.now().year);
    monthValue =
        findValue(list: widget.monthLabelList, value: DateTime.now().month);

    setCalendar();
    Offset getCenterOffset = getCenterPosition(
      widget.fullSize.width,
      widget.fullSize.height,
      widget.calendarSize,
      getFullCalendarHeight(widget.calendarSize),
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      for (var selectedItem in selectedItems!) {
        setBottomSelectedItems(selectedItem);
      }
    });

    // controller
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    paddingController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    startController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    resetBetweenControllerList();
    endController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    bottomRangeBtnCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    bottomBorderCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    bottomBorderExpandCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    if (widget.datePickerIconPosition != null) {
      // curve setting
      Animation<double> positionCurve = CurvedAnimation(
          parent: animationController, curve: Curves.easeInOutSine);
      Animation<double> scaleCurve = CurvedAnimation(
          parent: animationController, curve: Curves.easeInQuint);
      Animation<double> paddingCurve = CurvedAnimation(
          parent: paddingController, curve: Curves.easeInOutQuad);
      // animation setting
      animationCalendarTop = Tween<double>(
              begin: widget.datePickerIconPosition!.dy, end: getCenterOffset.dy)
          .animate(positionCurve);
      animationCalendarLeft = Tween<double>(
              begin: widget.datePickerIconPosition!.dx, end: getCenterOffset.dx)
          .animate(positionCurve);
      animationScale =
          Tween<double>(begin: widget.iconSize / widget.calendarSize, end: 1.0)
              .animate(scaleCurve);
      animationPadding = Tween<double>(
              begin: widget.calendarSize * 0.025,
              end: widget.calendarSize * 0.01)
          .animate(paddingCurve);
      animationBGBlur =
          Tween<double>(begin: 0, end: 1).animate(animationController);
      animationBGColor = ColorTween(
              begin: Colors.transparent, end: Colors.white.withOpacity(0.7))
          .animate(animationController);
      animationController.forward();

      // animation init
      setPreSelected();
    }
    if (datesRange.start != null) {
      setBottomStartFormat(
          yyyy: datesRange.start!.year,
          mm: datesRange.start!.month,
          dd: datesRange.start!.day);
      bottomBorderCtrl.forward(from: 1);
    }
    if (datesRange.end != null) {
      setBottomEndFormat(
          yyyy: datesRange.end!.year,
          mm: datesRange.end!.month,
          dd: datesRange.end!.day);
      bottomBorderExpandCtrl.forward(from: 1);
    }

    animationBorderExpand = Tween<double>(
            begin: bottomRangeBorderWidth, end: bottomRangeBorderExpandWidth)
        .animate(CurvedAnimation(
            parent: bottomBorderExpandCtrl, curve: Curves.easeOutQuint));
    nullAnimation =
        Tween<double>(begin: 0, end: 0).animate(animationController);

    super.initState();
  }

  void setPreSelected() {
    if (widget.isRange) {
      calendarInfo.dates.asMap().forEach((index, value) {
        List<DateInfo> preSelectedStartEndDates = calendarInfo.dates
            .where((date) =>
                date.isSelected == SelectType.start ||
                date.isSelected == SelectType.end)
            .toList();

        for (var element in preSelectedStartEndDates) {
          element.singleSelectedAniCtrl!.forward(from: 1);
        }

        if (value.isSelected == SelectType.between ||
            value.isSelected == SelectType.start ||
            value.isSelected == SelectType.end) {
          betweenControllerList[index].forward(from: 1);
        }
      });
    } else {
      List<DateInfo> preSelectedDates = calendarInfo.dates
          .where((date) => date.isSelected == SelectType.selected)
          .toList();
      for (var element in preSelectedDates) {
        element.singleSelectedAniCtrl!.forward(from: 1);
      }
    }
  }

  void setBottomSelectedItems(DateTime selectedItem) {
    bottomListKey.currentState!.insertItem(bottomSelectedItems!.length);
    bottomSelectedItems!.add(selectedItem);
  }

  Map findValue({required List list, required int value}) {
    return list.firstWhere((element) => element['value'] == value,
        orElse: () => {});
  }

  int findIndex({required List list, required Map target}) {
    return list.indexOf(target);
  }

  void setCalendar() {
    if (widget.isRange) {
      calendarInfo = CalendarInfo(
          firstWeekDay: widget.firstWeekDay,
          year: yearValue['value'], month: monthValue['value'], thisVsync: this)
        ..setSelectedBtwDates(
          datesRange: datesRange,
          disabledList: widget.disabledList,
          disabledRangeList: widget.disabledRangeList,
        );
    } else {
      calendarInfo = CalendarInfo(
        firstWeekDay: widget.firstWeekDay,
          year: yearValue['value'], month: monthValue['value'], thisVsync: this)
        ..setSelectedDates(
          selectedDates: selectedItems!,
          disabledList: widget.disabledList,
          disabledRangeList: widget.disabledRangeList,
        );
    }
  }

  void setCalcYearValue({required int calcYearValue}) {
    yearValue = findValue(list: widget.years, value: calcYearValue);
    yearDropdown.currentState!.setDefaultValue(defaultValue: yearValue);
  }

  void controlCalendar({required int number}) {
    int calcMonthValue = monthValue['value'] + number;
    int calcYearValue = yearValue['value'] + number;
    setState(() {
      if (calcMonthValue > 12) {
        calcMonthValue = 1;
        setCalcYearValue(calcYearValue: calcYearValue);
      } else if (calcMonthValue < 1) {
        calcMonthValue = 12;
        setCalcYearValue(calcYearValue: calcYearValue);
      }
      monthValue =
          findValue(list: widget.monthLabelList, value: calcMonthValue);
      setCalendar();
    });
    monthDropdown.currentState!.setDefaultValue(defaultValue: monthValue);
  }

  void limitCalendar({required int number}) {
    int currentYearIndex = findIndex(list: widget.years, target: yearValue);
    int currentMonthIndex =
        findIndex(list: widget.monthLabelList, target: monthValue);
    if (number == -1) {
      if ((currentYearIndex != widget.years.length - 1) ||
          (currentMonthIndex != 0)) {
        controlCalendar(number: number);
      }
    } else if (number == 1) {
      if ((currentYearIndex != 0) ||
          (currentMonthIndex != widget.monthLabelList.length - 1)) {
        controlCalendar(number: number);
      }
    }
  }

  String setFormat({int? yyyy, int? mm, int? dd}) {
    return widget.format
        .replaceAll('yyyy', yyyy.toString())
        .replaceAll('mm',
            mm.toString().length == 1 ? '0' + mm.toString() : mm.toString())
        .replaceAll('dd',
            dd.toString().length == 1 ? '0' + dd.toString() : dd.toString());
  }

  void setBottomStartFormat({int? yyyy, int? mm, int? dd}) {
    setState(() {
      startDateStr = (yyyy != null)
          ? widget.format
              .replaceAll('yyyy', yyyy.toString())
              .replaceAll(
                  'mm',
                  mm.toString().length == 1
                      ? '0' + mm.toString()
                      : mm.toString())
              .replaceAll(
                  'dd',
                  dd.toString().length == 1
                      ? '0' + dd.toString()
                      : dd.toString())
          : '';
    });
  }

  void setBottomEndFormat({int? yyyy, int? mm, int? dd}) {
    setState(() {
      endDateStr = (yyyy != null)
          ? widget.format
              .replaceAll('yyyy', yyyy.toString())
              .replaceAll(
                  'mm',
                  mm.toString().length == 1
                      ? '0' + mm.toString()
                      : mm.toString())
              .replaceAll(
                  'dd',
                  dd.toString().length == 1
                      ? '0' + dd.toString()
                      : dd.toString())
          : '';
    });
  }

  Color textColor(SelectType selectType) {
    if (selectType == SelectType.disabled) {
      return Colors.grey.withOpacity(0.3);
    } else if (selectType == SelectType.start ||
        selectType == SelectType.end ||
        selectType == SelectType.selected) {
      return Colors.white;
    } else {
      return widget.isDark ? Colors.white : Color(0xff333333);
    }
  }

  Widget dropdown({
    required double width,
    required Function onChange,
    required Key key,
    required List dropdownList,
    required Map defaultValue,
    required double thisWidth,
  }) {
    return CoolDropdown(
      key: key,
      dropdownList: dropdownList,
      onChange: onChange,
      defaultValue: defaultValue,
      resultWidth: thisWidth,
      resultPadding: EdgeInsets.only(right: 0, left: 0),
      resultHeight: width * 0.1,
      resultTS: TextStyle(fontSize: width * 0.045, color: Colors.white),
      resultMainAxis: MainAxisAlignment.center,
      labelIconGap: 0,
      resultIconLeftGap: 0,
      dropdownItemMainAxis: MainAxisAlignment.center,
      dropdownWidth: thisWidth,
      dropdownHeight: width * 0.75,
      dropdownPadding: EdgeInsets.zero,
      dropdownItemTopGap: 0,
      dropdownItemBottomGap: 0,
      dropdownItemHeight: width * 0.125,
      dropdownItemGap: 0,
      unselectedItemTS: TextStyle(fontSize: width * 0.04, color: Colors.black),
      selectedItemBD: BoxDecoration(
          border: Border.all(width: 0.5, color: Color(0XFFF4F4F4)),
          color: Color(0XFFF4F4F4)),
      selectedItemTS: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.04),
      dropdownBD: BoxDecoration(
          border: Border.all(width: 0.5, color: Color(0XFFDDDDDD)),
          color: Colors.white),
      resultBD: BoxDecoration(),
      isTriangle: false,
      gap: 0,
    );
  }

  void resetBetweenControllerList() {
    betweenControllerList = [];

    for (var element in calendarInfo.dates) {
      betweenControllerList.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 50)));
    }
  }

  Widget arrowButton({required double width, required String type}) {
    return GestureDetector(
      onTapDown: (_) async {
        isRight = (type == 'right');
        await paddingController.forward();
      },
      onTapUp: (_) async {
        await paddingController.reverse();
        limitCalendar(number: type == 'right' ? 1 : -1);
        // betweenController 초기화 후 배열에 맞게 재셋팅
        resetBetweenControllerList();
        setPreSelected();
      },
      child: Container(
        width: width * 0.075,
        height: width * 0.075,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: widget.arrowIconAreaColor),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: width * 0.025,
                height: width * 0.025,
                child: CustomPaint(
                  size: Size(width * 0.01, (width * 0.01 * 1).toDouble()),
                  painter:
                      type == 'right' ? RightArrowPaint() : LeftArrowPaint(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomButton(BuildContext context, int index, animation) {
    double width = widget.datePickerIconPosition != null
        ? widget.calendarSize
        : widget.iconSize;
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.horizontal,
      axisAlignment: -1,
      child: ScaleTransition(
        alignment: Alignment.centerLeft,
        scale: Tween<double>(begin: 0, end: 1).animate(animation),
        child: Row(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: setDarkColor(),
                  borderRadius: BorderRadius.circular(width * 0.06),
                  border:
                      Border.all(color: widget.selectedCircleColor, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(width * 0.06),
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      // highlightColor: Color(0XFFF4F4F4).withOpacity(1.0),
                      // splashColor: Colors.grey.withOpacity(0.7),
                      onTap: () {
                        setState(() {
                          yearValue = findValue(
                              list: widget.years,
                              value: bottomSelectedItems![index].year);
                          monthValue = findValue(
                              list: widget.monthLabelList,
                              value: bottomSelectedItems![index].month);
                          setCalendar();
                          setPreSelected();
                          yearDropdown.currentState!
                              .setDefaultValue(defaultValue: yearValue);
                          monthDropdown.currentState!
                              .setDefaultValue(defaultValue: monthValue);
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              width * 0.02,
                              width * 0.015,
                              width * 0.02,
                              width * 0.015,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  child: AnimatedSize(
                                    duration: Duration(milliseconds: 1000),
                                    child: Text(
                                      setFormat(
                                        yyyy: index >=
                                                bottomSelectedItems!.length
                                            ? 0000
                                            : bottomSelectedItems![index].year,
                                        mm: index >= bottomSelectedItems!.length
                                            ? 0
                                            : bottomSelectedItems![index].month,
                                        dd: index >= bottomSelectedItems!.length
                                            ? 0
                                            : bottomSelectedItems![index].day,
                                      ),
                                      style: TextStyle(
                                          fontSize: width * 0.033,
                                          color: widget.isDark
                                              ? Colors.white
                                              : Color(0XFF666666),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.015,
                                ),
                                Container(
                                  padding: EdgeInsets.all(width * 0.005),
                                  width: width * 0.03,
                                  height: width * 0.03,
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (calendarInfo.year ==
                                          selectedItems![index].year &&
                                      calendarInfo.month ==
                                          selectedItems![index].month) {
                                    DateInfo selectedDates6 = calendarInfo.dates
                                        .singleWhere((element) =>
                                            element.date ==
                                            selectedItems![index].day);
                                    selectedDates6.isSelected = SelectType.none;
                                    selectedDates6.singleSelectedAniCtrl!
                                        .reverse();
                                  }
                                  selectedItems!.remove(selectedItems![index]);
                                  removeBottomSelectedItemsXBtn(index);
                                });
                                // widget.onSelected(
                                //     selectedItems);
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(width * 0.025),
                                width: width * 0.075,
                                height: width * 0.075,
                                child: CustomPaint(
                                  size: Size(width * 0.01,
                                      (width * 0.01 * 1).toDouble()),
                                  painter: XButtonPaint(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if ((selectedItems!.length - 1) != index)
              SizedBox(
                width: width * 0.015,
              )
          ],
        ),
      ),
    );
  }

  void removeBottomSelectedItems(
      DateInfo date, CalendarInfo calenderInfo) async {
    int bottomSelectedItemsIndex = bottomSelectedItems!
        .indexWhere((element1) => element1.day == date.date!);
    bottomListKey.currentState!.removeItem(
        bottomSelectedItemsIndex,
        (context, animation) =>
            bottomButton(context, bottomSelectedItemsIndex, animation));
    bottomSelectedItems!.remove(bottomSelectedItems!.firstWhere((element1) =>
        element1.day == date.date! &&
        element1.year == calendarInfo.year &&
        element1.month == calenderInfo.month));
  }

  void removeBottomSelectedItemsXBtn(int index) {
    bottomListKey.currentState!.removeItem(
        index, (context, animation) => bottomButton(context, index, animation));
    bottomSelectedItems!.remove(bottomSelectedItems![index]);
  }

  Widget single({
    required CalendarInfo calendarInfo,
    required DateInfo date,
    required double width,
  }) {
    return InkWell(
      onTap: () {
        if (date.date != null) {
          if (date.isSelected != SelectType.disabled) {
            setState(() {
              int bottomSelectedItemsIndex;
              if (date.isSelected == SelectType.selected) {
                selectedItems!.remove(selectedItems!
                    .singleWhere((element) => (element.day == date.date!)));
                removeBottomSelectedItems(date, calendarInfo);
                date.isSelected = SelectType.none;
                date.singleSelectedAniCtrl!.reverse();
              } else {
                DateTime selectedDate1 = DateTime(
                  calendarInfo.year,
                  calendarInfo.month,
                  date.date!,
                );
                if (widget.limitCount <= selectedItems!.length) {
                  // 날짜 삭제
                  if (calendarInfo.year == selectedItems![0].year &&
                      calendarInfo.month == selectedItems![0].month) {
                    DateInfo selectedDate5 = calendarInfo.dates.singleWhere(
                        (element2) => element2.date == selectedItems![0].day);
                    selectedDate5.isSelected = SelectType.none;
                    selectedDate5.singleSelectedAniCtrl!.reverse();
                  }
                  selectedItems!.removeAt(0);
                  removeBottomSelectedItemsXBtn(0);

                  // 날짜 추가
                  selectedItems!.add(selectedDate1);
                  setBottomSelectedItems(selectedDate1);
                  DateInfo selectedDate4 = calendarInfo.dates.singleWhere(
                      (element3) => element3.date == selectedDate1.day);
                  selectedDate4.isSelected = SelectType.selected;
                  selectedDate4.singleSelectedAniCtrl!.forward();

                  bottomSelectedItemsIndex = bottomSelectedItems!
                      .indexWhere((element1) => element1.day == date.date!);
                } else {
                  selectedItems!.add(selectedDate1);
                  setBottomSelectedItems(selectedDate1);
                  bottomSelectedItemsIndex = bottomSelectedItems!
                      .indexWhere((element1) => element1.day == date.date!);
                  date.isSelected = SelectType.selected;
                  date.singleSelectedAniCtrl!.forward();
                }
              }
            });
            // widget.onSelected(selectedItems);
            // widget.getSelectedItems(selectedItems);
          }
        }
      },
      child: Container(
        width: width / 7,
        height: width / 9,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ScaleTransition(
                scale: (date.singleScaleAnimation != null)
                    ? date.singleScaleAnimation!
                    : nullAnimation,
                child: Container(
                  width: width / 12,
                  height: width / 12,
                  decoration: BoxDecoration(
                    color: widget.selectedCircleColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: date.date != null
                  ? Text(
                      date.date.toString(),
                      style: TextStyle(
                          fontSize: width * 0.033,
                          color: textColor(date.isSelected)),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  void resetCalendar() {
    datesRange.start = null;
    datesRange.end = null;
    setBottomStartFormat();
    setBottomEndFormat();
    for (var date in calendarInfo.dates) {
      if (date.isSelected != SelectType.disabled) {
        date.isSelected = SelectType.none;
        if (date.singleSelectedAniCtrl != null) {
          date.singleSelectedAniCtrl!.reverse();
        }
      }
    }
  }

  void setRangeSelect() {
    widget.onSelected({'start': datesRange.start, 'end': datesRange.end});
    widget.getSelectedItems({'start': datesRange.start, 'end': datesRange.end});
  }

  void setStart({required DateInfo date, required DateTime selectedDates}) {
    date.isSelected = SelectType.start;
    datesRange.start = selectedDates;
    // animation reset
    for (var element in betweenControllerList) {
      element.reset();
    }
  }

  void setOrderRangeAnimation(int startIndex, int endIndex) async {
    try {
      for (var i = startIndex; i <= endIndex; i++) {
        if (i >= 0) {
          await betweenControllerList[i].forward();
        }
      }
    } catch (e) {}
  }

  Widget range({
    required CalendarInfo calendarInfo,
    required DateInfo date,
    required double width,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        if (date.date != null) {
          if (date.isSelected != SelectType.empty) {
            if (date.isSelected != SelectType.disabled) {
              setState(() {
                if (calendarInfo.dates.length > 0) {
                  DateTime selectedDates = DateTime(
                      calendarInfo.year, calendarInfo.month, date.date!);
                  if (datesRange.start != null && datesRange.end != null) {
                    resetCalendar();
                    setStart(date: date, selectedDates: selectedDates);
                    setBottomStartFormat(
                        yyyy: calendarInfo.year,
                        mm: calendarInfo.month,
                        dd: date.date);
                    date.singleSelectedAniCtrl!.forward();
                    bottomBorderExpandCtrl.reverse();
                  } else if (datesRange.start != null) {
                    if (datesRange.start!.compare(selectedDates)) {
                      resetCalendar();
                      bottomBorderCtrl.reverse();
                    } else {
                      if (datesRange.start!.isBefore(selectedDates)) {
                        date.isSelected = SelectType.end;
                        datesRange.end = selectedDates;
                        datesRange.start = datesRange.start;
                        setBottomEndFormat(
                            yyyy: datesRange.end!.year,
                            mm: datesRange.end!.month,
                            dd: datesRange.end!.day);
                        date.singleSelectedAniCtrl!.forward();
                        setBottomStartFormat(
                            yyyy: datesRange.start!.year,
                            mm: datesRange.start!.month,
                            dd: datesRange.start!.day);
                        bottomBorderCtrl.forward();
                        bottomBorderExpandCtrl.forward();
                      } else {
                        date.isSelected = SelectType.start;

                        datesRange.end = DateTime(
                            // 깊은 복사
                            datesRange.start!.year,
                            datesRange.start!.month,
                            datesRange.start!.day);
                        setBottomStartFormat(
                            yyyy: selectedDates.year,
                            mm: selectedDates.month,
                            dd: selectedDates.day);
                        setBottomEndFormat(
                            yyyy: datesRange.end!.year,
                            mm: datesRange.end!.month,
                            dd: datesRange.end!.day);
                        datesRange.start = selectedDates;
                        date.singleSelectedAniCtrl!.forward();

                        for (var element in calendarInfo.dates) {
                          if (element.date == datesRange.end!.day) {
                            if (datesRange.end!.month == calendarInfo.month) {
                              element.isSelected = SelectType.end;
                              date.singleSelectedAniCtrl!.forward();
                              bottomBorderCtrl.forward();
                              bottomBorderExpandCtrl.forward();
                            } else {
                              if (element.isSelected == SelectType.disabled) {
                                element.isSelected = SelectType.disabled;
                              } else {
                                element.isSelected = SelectType.none;
                                element.singleSelectedAniCtrl!.reverse();
                              }
                            }
                          }
                        }
                      }
                      // start 데이트 셋팅
                      DateTime currentMonthStartDate = (datesRange
                                  .start!.month ==
                              calendarInfo.month) // 달이 같을 때와 다를 때
                          ? datesRange.start!.year !=
                                  calendarInfo.year // 연도가 같을 때와 다를 때
                              ? DateTime(
                                  calendarInfo.year, calendarInfo.month, 0)
                              : datesRange.start!
                          : DateTime(calendarInfo.year, calendarInfo.month, 0);
                      DateTime currentMonthEndDate = (datesRange.end!.month ==
                              calendarInfo.month)
                          ? datesRange.end!.year != calendarInfo.year
                              ? DateTime(
                                  calendarInfo.year, calendarInfo.month + 1, 1)
                              : datesRange.end!
                          : DateTime(
                              calendarInfo.year, calendarInfo.month + 1, 1);
                      bottomRangeBtnCtrl.forward();
                      bottomBorderExpandCtrl.forward();
                      // between 셋팅
                      int startIndex;
                      int endIndex;
                      if (datesRange.start != null && datesRange.end != null) {
                        if (currentMonthEndDate.day -
                                currentMonthStartDate.day !=
                            1) {
                          List<DateTime> actualBetweenDates =
                              currentMonthStartDate.getBtwDates(
                                  end: currentMonthEndDate);
                          startIndex = calendarInfo.dates.indexWhere(
                              (datesIndex) =>
                                  datesIndex.date == actualBetweenDates[0].day);
                          endIndex = calendarInfo.dates.indexWhere(
                              (datesIndex) =>
                                  datesIndex.date ==
                                  actualBetweenDates[
                                          actualBetweenDates.length - 1]
                                      .day);
                          for (var btwDate1 in actualBetweenDates) {
                            for (var element1 in calendarInfo.dates) {
                              if (element1.isSelected != SelectType.disabled) {
                                if (element1.date == btwDate1.day) {
                                  element1.isSelected = SelectType.between;
                                }
                              }
                            }
                          }
                        } else {
                          startIndex = calendarInfo.dates.indexWhere(
                              (datesIndex) =>
                                  datesIndex.date == currentMonthStartDate.day);
                          endIndex = calendarInfo.dates.indexWhere(
                              (datesIndex) =>
                                  datesIndex.date == currentMonthEndDate.day);
                        }
                        setOrderRangeAnimation(
                            currentMonthStartDate.month == calendarInfo.month
                                ? startIndex - 1
                                : startIndex,
                            currentMonthEndDate.month == calendarInfo.month
                                ? endIndex + 1
                                : endIndex);
                      }
                    }
                  } else {
                    setStart(date: date, selectedDates: selectedDates);
                    setBottomStartFormat(
                        yyyy: calendarInfo.year,
                        mm: calendarInfo.month,
                        dd: date.date);
                    bottomBorderCtrl.forward();
                    date.singleSelectedAniCtrl!.forward();
                    setBottomStartFormat(
                        yyyy: calendarInfo.year,
                        mm: calendarInfo.month,
                        dd: date.date);
                  }
                  // setRangeSelect();
                }
              });
              if (datesRange.start != null && datesRange.end != null) {
                // setRangeSelect();
              }
              // setSizedBottomRightBtn(
              //                               defaultSize: width * 0.06,
              //                               oneSelectedSize: width * 0.045,
              //                               multipleSelectedSize:
              //                                   width * 0.03);
            }
          }
        }
      },
      child: Container(
        width: width / 7,
        height: width / 9,
        child: Stack(
          children: [
            outerCircle(date, width, index),
            startArea(date, width, index),
            betweenArea(date, width, index),
            endArea(date, width, index),
            innerCircle(date, width, index),
            Align(
              alignment: Alignment.center,
              child: date.date != null
                  ? Text(date.date.toString(),
                      style: TextStyle(
                        fontSize: width * 0.033,
                        color: textColor(date.isSelected),
                      ))
                  : Container(),
            )
          ],
        ),
      ),
    );
  }

  Widget sizedWidget(
      {required Widget child,
      required AnimationController sizeFactor,
      required bool condition}) {
    return condition
        ? SizeTransition(
            sizeFactor: sizeFactor,
            child: child,
            axis: Axis.horizontal,
            axisAlignment: -1,
          )
        : Container(
            // child: child,
            );
  }

  Widget outerCircle(DateInfo date, double width, int index) {
    return Align(
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: (date.singleScaleAnimation != null)
            ? date.singleScaleAnimation!
            : nullAnimation,
        child: Container(
          width: width / 10,
          height: width / 10,
          decoration: BoxDecoration(
            color: widget.selectedBetweenAreaColor,
            boxShadow: [
              BoxShadow(
                color: widget.selectedBetweenAreaColor,
                spreadRadius: width * 0.0025,
              )
            ],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget innerCircle(DateInfo date, double width, int index) {
    return Align(
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: (date.singleScaleAnimation != null)
            ? date.singleScaleAnimation!
            : nullAnimation,
        child: Container(
          width: width / 13,
          height: width / 13,
          decoration: BoxDecoration(
            color: widget.selectedCircleColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget startArea(DateInfo date, double width, int index) {
    return sizedWidget(
      sizeFactor: betweenControllerList[index],
      condition: (date.isSelected == SelectType.start &&
          (datesRange.start != null && datesRange.end != null)),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: width / 14,
          height: width / 10,
          decoration: BoxDecoration(
            color: widget.selectedBetweenAreaColor,
            boxShadow: [
              BoxShadow(
                color: widget.selectedBetweenAreaColor,
                spreadRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget betweenArea(DateInfo date, double width, int index) {
    return sizedWidget(
      sizeFactor: betweenControllerList[index],
      condition: (date.isSelected == SelectType.between),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: width * 0.1,
          decoration: BoxDecoration(
            color: widget.selectedBetweenAreaColor,
            boxShadow: [
              BoxShadow(
                color: widget.selectedBetweenAreaColor,
                spreadRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget endArea(DateInfo date, double width, int index) {
    return sizedWidget(
      sizeFactor: betweenControllerList[index],
      condition: (date.isSelected == SelectType.end),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: width / 14,
          height: width / 10,
          decoration: BoxDecoration(
            color: widget.selectedBetweenAreaColor,
            boxShadow: [
              BoxShadow(
                color: widget.selectedBetweenAreaColor,
                spreadRadius: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomRangeLabel(
      {required double width, DateTime? target, required bool isStart}) {
    return InkWell(
      highlightColor: Color(0XFFF4F4F4).withOpacity(1.0),
      splashColor: Colors.grey.withOpacity(0.7),
      onTap: () {
        setState(() {
          yearValue = findValue(list: widget.years, value: target!.year);
          monthValue =
              findValue(list: widget.monthLabelList, value: target.month);
          setCalendar();
          resetBetweenControllerList();
          setPreSelected();
          yearDropdown.currentState!.setDefaultValue(defaultValue: yearValue);
          monthDropdown.currentState!.setDefaultValue(defaultValue: monthValue);
        });
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInQuart)),
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 3), end: Offset.zero)
                  .animate(CurvedAnimation(
                      parent: animation, curve: Curves.easeInOutBack)),
              child: SizeTransition(
                child: child,
                sizeFactor: animation,
                axisAlignment: -1,
              ),
            ),
          );
        },
        child: Text(
          isStart ? startDateStr : endDateStr,
          key: ValueKey<String>(isStart ? startDateStr : endDateStr),
          style: TextStyle(
              fontSize: width * 0.033,
              color: widget.isDark ? Color(0xffffffff) : Color(0XFF666666),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget wrapCalendar({required Widget child}) {
    return widget.datePickerIconPosition != null
        ? Stack(
            children: [
              AnimatedBuilder(
                  builder: (BuildContext context, Widget? _) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: max(0.001, 10 * animationBGBlur!.value),
                          sigmaY: max(0.001, 10 * animationBGBlur!.value)),
                      child: GestureDetector(
                        onTap: () {
                          widget.onSelected(selectedItemsHistory);
                          widget.getSelectedItems(selectedItemsHistory);
                          widget.closeCalendar();
                        },
                        child: Container(
                          width: MediaQuery.of(widget.parentBuildContext)
                              .size
                              .width,
                          height: MediaQuery.of(widget.parentBuildContext)
                              .size
                              .height,
                          color: animationBGColor!.value,
                        ),
                      ),
                    );
                  },
                  animation: animationController),
              AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget? _) {
                    return Positioned(
                      top: animationCalendarTop!.value,
                      left: animationCalendarLeft!.value,
                      child: ScaleTransition(
                        alignment: Alignment.topLeft,
                        child: child,
                        scale: animationScale!,
                      ),
                    );
                  })
            ],
          )
        : child;
  }

  void setSizedBottomRightBtn(
      {required double defaultSize,
      required double oneSelectedSize,
      required double multipleSelectedSize}) {
    setState(() {
      if (datesRange.start != null || selectedItems!.length > 0) {
        bottomRightSizedWidth = oneSelectedSize;
      }
      if ((datesRange.start != null && datesRange.end != null) ||
          selectedItems!.length > 1) {
        bottomRightSizedWidth = multipleSelectedSize;
      }
      if ((datesRange.start == null && datesRange.end == null) ||
          (selectedItems == null || selectedItems!.length < 1)) {
        bottomRightSizedWidth = defaultSize;
      }
    });
  }

  Offset getCenterPosition(double fullWidth, double fullHeight,
      double calendarWidth, double calendarHeight) {
    return Offset(
        (fullWidth - calendarWidth) / 2, (fullHeight - calendarHeight) / 2);
  }

  double getFullCalendarWidth(double calendarSize) {
    return calendarSize;
  }

  double getFullCalendarHeight(double calendarSize) {
    return calendarSize * 0.25 + calendarSize / 9 + calendarSize * 6 / 9;
  }

  double getFontWidth(String text, TextStyle style, BuildContext context) {
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout();
    return textPainter.size.width;
  }

  Color setDarkColor() {
    return widget.isDark ? Color(0xff595959) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    // 스크린 값
    double _screenWidth = widget.datePickerIconPosition != null
        ? widget.calendarSize
        : widget.iconSize;
    double _padding = _screenWidth * 0.025;
    double _calendarHeight =
        _screenWidth * 0.25 + _screenWidth / 9 + _screenWidth * 6 / 9;

    return Material(
      type: MaterialType.transparency,
      child: wrapCalendar(
        child: Container(
          width: _screenWidth,
          height: _calendarHeight,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenWidth * 0.025),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: _screenWidth * 0.001,
                        blurRadius: _screenWidth * 0.05,
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_screenWidth * 0.025),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: paddingController,
                          builder: (BuildContext context, Widget? _) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: animationPadding != null
                                      ? isRight
                                          ? _padding
                                          : animationPadding!.value
                                      : _padding,
                                  right: animationPadding != null
                                      ? !isRight
                                          ? _padding
                                          : animationPadding!.value
                                      : _padding),
                              color: widget.headerColor,
                              width: _screenWidth,
                              height: _screenWidth * 0.125,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  arrowButton(
                                    width: _screenWidth,
                                    type: 'left',
                                  ),
                                  Center(
                                    child: Row(
                                      children: [
                                        dropdown(
                                          width: _screenWidth,
                                          key: yearDropdown,
                                          dropdownList: widget.years,
                                          onChange: (selectedItem) {
                                            setState(() {
                                              yearValue = selectedItem;
                                              setCalendar();
                                              resetBetweenControllerList();
                                              setPreSelected();
                                            });
                                          },
                                          defaultValue: yearValue,
                                          thisWidth: _screenWidth * 0.17,
                                        ),
                                        dropdown(
                                          key: monthDropdown,
                                          dropdownList: widget.monthLabelList,
                                          onChange: (selectedItem) {
                                            setState(() {
                                              monthValue = selectedItem;
                                              setCalendar();
                                              resetBetweenControllerList();
                                              setPreSelected();
                                            });
                                          },
                                          defaultValue: monthValue,
                                          width: _screenWidth,
                                          thisWidth: widget
                                                  .maxMonthDropdownWidth +
                                              (widget.datePickerIconPosition !=
                                                      null
                                                  ? 20
                                                  : 0),
                                        )
                                      ].isReverse(
                                          widget.isYearMonthDropdownReverse),
                                    ),
                                  ),
                                  arrowButton(
                                    width: _screenWidth,
                                    type: 'right',
                                  )
                                ],
                              ),
                            );
                          }),
                      Container(
                        width: _screenWidth,
                        height: _screenWidth / 9,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: setDarkColor(), spreadRadius: 1)
                          ],
                          color: setDarkColor(),
                        ),
                        // color: setDarkColor(),
                        child: Row(
                          children: widget.weekLabelList.map<Widget>((weekday) {
                            return Container(
                              width: _screenWidth / 7,
                              height: _screenWidth / 9,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  weekday['label'],
                                  style: TextStyle(
                                    fontSize: _screenWidth * 0.033,
                                    color: widget.isDark
                                        ? weekday['color']
                                                    .value
                                                    .toRadixString(16) ==
                                                'ff333333'
                                            ? Colors.white
                                            : weekday['color']
                                        : weekday['color'],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        width: _screenWidth,
                        height: _screenWidth * 6 / 9,
                        color: setDarkColor(),
                        child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            crossAxisCount: 7,
                            shrinkWrap: true,
                            childAspectRatio:
                                (_screenWidth / 7) / (_screenWidth / 9),
                            children: calendarInfo.dates
                                .mapIndexed<Widget>((date, index) {
                              return widget.isRange
                                  ? range(
                                      calendarInfo: calendarInfo,
                                      date: date,
                                      width: _screenWidth,
                                      index: index,
                                    )
                                  : single(
                                      calendarInfo: calendarInfo,
                                      date: date,
                                      width: _screenWidth,
                                    );
                            }).toList()),
                      ),
                      Container(
                        width: _screenWidth,
                        height: _screenWidth * 0.125,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: setDarkColor(), spreadRadius: 1)
                          ],
                          color: setDarkColor(),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: _screenWidth * 0.03,
                            ),
                            Expanded(
                              child: widget.isRange
                                  ? ListView(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Row(
                                          children: [
                                            CustomPaint(
                                              foregroundPainter: BottomBorderBox(
                                                  CurvedAnimation(
                                                      parent: bottomBorderCtrl,
                                                      curve:
                                                          Curves.easeInQuart),
                                                  widget
                                                      .bottomSelectedBorderColor),
                                              child: AnimatedBuilder(
                                                  animation:
                                                      bottomBorderExpandCtrl,
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? _) {
                                                    return Container(
                                                      width:
                                                          animationBorderExpand
                                                              .value,
                                                      height:
                                                          bottomRangeBorderHeight,
                                                      child: ListView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        children: [
                                                          SizedBox(
                                                            width:
                                                                _screenWidth *
                                                                    0.02,
                                                          ),
                                                          Container(
                                                            child:
                                                                bottomRangeLabel(
                                                              width:
                                                                  _screenWidth,
                                                              target: datesRange
                                                                  .start,
                                                              isStart: true,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                _screenWidth *
                                                                    0.015,
                                                          ),
                                                          Center(
                                                            child:
                                                                ScaleTransition(
                                                              scale: Tween<
                                                                          double>(
                                                                      begin: 0,
                                                                      end: 1)
                                                                  .animate(CurvedAnimation(
                                                                      parent:
                                                                          bottomBorderCtrl,
                                                                      curve: Curves
                                                                          .easeOutBack)),
                                                              child: Text('~',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          _screenWidth *
                                                                              0.03,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: widget.isDark
                                                                          ? Colors
                                                                              .white
                                                                          : Color(
                                                                              0xff333333))),
                                                            ),
                                                          ),
                                                          AnimatedContainer(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    300),
                                                            width: datesRange
                                                                        .end !=
                                                                    null
                                                                ? _screenWidth *
                                                                    0.015
                                                                : 0,
                                                          ),
                                                          Container(
                                                            child:
                                                                bottomRangeLabel(
                                                              width:
                                                                  _screenWidth,
                                                              target: datesRange
                                                                  .end,
                                                              isStart: false,
                                                            ),
                                                          ),
                                                          SizeTransition(
                                                            sizeFactor: Tween<
                                                                        double>(
                                                                    begin: 0,
                                                                    end: 1)
                                                                .animate(CurvedAnimation(
                                                                    parent:
                                                                        bottomBorderCtrl,
                                                                    curve: Curves
                                                                        .easeOutBack)),
                                                            axis:
                                                                Axis.horizontal,
                                                            axisAlignment: 5,
                                                            child: Container(
                                                              color: Colors
                                                                  .transparent,
                                                              width:
                                                                  _screenWidth *
                                                                      0.06,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    resetCalendar();
                                                                    bottomBorderCtrl
                                                                        .reverse();
                                                                    bottomBorderExpandCtrl
                                                                        .reverse();
                                                                    setRangeSelect();
                                                                  });
                                                                },
                                                                child: Center(
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        _screenWidth *
                                                                            0.03,
                                                                    height:
                                                                        _screenWidth *
                                                                            0.03,
                                                                    child:
                                                                        CustomPaint(
                                                                      painter:
                                                                          XButtonPaint(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : AnimatedList(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      key: bottomListKey,
                                      scrollDirection: Axis.horizontal,
                                      initialItemCount:
                                          bottomSelectedItems!.length,
                                      itemBuilder: (context, index, animation) {
                                        return bottomButton(
                                            context, index, animation);
                                      }),
                            ),
                            SizedBox(
                              width: _screenWidth * 0.03,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: _screenWidth * 0.03,
                                ),
                                InkWell(
                                  onTap: () {
                                    widget.onSelected(selectedItemsHistory);
                                    widget
                                        .getSelectedItems(selectedItemsHistory);
                                    widget.closeCalendar();
                                  },
                                  child: Container(
                                    child: Text(
                                      widget.cancelBtnLabel,
                                      style: TextStyle(
                                          fontSize: _screenWidth * 0.033,
                                          color: widget.cancelFontColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                if (widget.isRange)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeOutQuad,
                                    width: (datesRange.start != null)
                                        ? (datesRange.end != null)
                                            ? _screenWidth * 0.045
                                            : _screenWidth * 0.075
                                        : _screenWidth * 0.09,
                                  ),
                                if (!widget.isRange)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeOutQuad,
                                    width: (selectedItems!.length > 0)
                                        ? (selectedItems!.length > 1)
                                            ? _screenWidth * 0.045
                                            : _screenWidth * 0.075
                                        : _screenWidth * 0.09,
                                  ),
                                InkWell(
                                  onTap: () {
                                    if (widget.isRange) {
                                      setRangeSelect();
                                    } else {
                                      widget.onSelected(selectedItems);
                                      widget.getSelectedItems(selectedItems);
                                    }
                                    widget.closeCalendar();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        _screenWidth * 0.03,
                                        _screenWidth * 0.015,
                                        _screenWidth * 0.03,
                                        _screenWidth * 0.015),
                                    decoration: BoxDecoration(
                                      gradient: widget.okButtonColor,
                                      borderRadius: BorderRadius.circular(
                                          _screenWidth * 0.06),
                                    ),
                                    child: Text(
                                      widget.okBtnLabel,
                                      style: TextStyle(
                                        fontSize: _screenWidth * 0.033,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.isRange)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeOutQuad,
                                    width: (datesRange.start != null)
                                        ? (datesRange.end != null)
                                            ? _screenWidth * 0.03
                                            : _screenWidth * 0.06
                                        : _screenWidth * 0.09,
                                  ),
                                if (!widget.isRange)
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.easeOutQuad,
                                    width: (selectedItems!.length > 0)
                                        ? (selectedItems!.length > 1)
                                            ? _screenWidth * 0.03
                                            : _screenWidth * 0.06
                                        : _screenWidth * 0.09,
                                  ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class LeftArrowPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4036748, size.height * 0.5002114);
    path_0.lineTo(size.width * 0.7777724, size.height * 0.1260976);
    path_0.cubicTo(
        size.width * 0.7880732,
        size.height * 0.1158211,
        size.width * 0.7937398,
        size.height * 0.1020813,
        size.width * 0.7937398,
        size.height * 0.08743089);
    path_0.cubicTo(
        size.width * 0.7937398,
        size.height * 0.07277236,
        size.width * 0.7880732,
        size.height * 0.05904065,
        size.width * 0.7777724,
        size.height * 0.04874797);
    path_0.lineTo(size.width * 0.7449919, size.height * 0.01598374);
    path_0.cubicTo(size.width * 0.7347073, size.height * 0.005674797,
        size.width * 0.7209593, 0, size.width * 0.7063089, 0);
    path_0.cubicTo(
        size.width * 0.6916585,
        0,
        size.width * 0.6779268,
        size.height * 0.005674797,
        size.width * 0.6676341,
        size.height * 0.01598374);
    path_0.lineTo(size.width * 0.2222114, size.height * 0.4613984);
    path_0.cubicTo(
        size.width * 0.2118780,
        size.height * 0.4717236,
        size.width * 0.2062195,
        size.height * 0.4855203,
        size.width * 0.2062602,
        size.height * 0.5001870);
    path_0.cubicTo(
        size.width * 0.2062195,
        size.height * 0.5149187,
        size.width * 0.2118699,
        size.height * 0.5286992,
        size.width * 0.2222114,
        size.height * 0.5390325);
    path_0.lineTo(size.width * 0.6672195, size.height * 0.9840163);
    path_0.cubicTo(
        size.width * 0.6775122,
        size.height * 0.9943252,
        size.width * 0.6912439,
        size.height * 1.000000,
        size.width * 0.7059024,
        size.height * 1.000000);
    path_0.cubicTo(
        size.width * 0.7205528,
        size.height * 1.000000,
        size.width * 0.7342846,
        size.height * 0.9943252,
        size.width * 0.7445854,
        size.height * 0.9840163);
    path_0.lineTo(size.width * 0.7773577, size.height * 0.9512520);
    path_0.cubicTo(
        size.width * 0.7986829,
        size.height * 0.9299268,
        size.width * 0.7986829,
        size.height * 0.8952114,
        size.width * 0.7773577,
        size.height * 0.8738943);
    path_0.lineTo(size.width * 0.4036748, size.height * 0.5002114);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RightArrowPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.7777945, size.height * 0.4609800);
    path_0.lineTo(size.width * 0.3327818, size.height * 0.01597548);
    path_0.cubicTo(size.width * 0.3224892, size.height * 0.005674751,
        size.width * 0.3087495, 0, size.width * 0.2940992, 0);
    path_0.cubicTo(
        size.width * 0.2794489,
        0,
        size.width * 0.2657092,
        size.height * 0.005674751,
        size.width * 0.2554166,
        size.height * 0.01597548);
    path_0.lineTo(size.width * 0.2226445, size.height * 0.04873944);
    path_0.cubicTo(
        size.width * 0.2013195,
        size.height * 0.07008886,
        size.width * 0.2013195,
        size.height * 0.1047878,
        size.width * 0.2226445,
        size.height * 0.1261047);
    path_0.lineTo(size.width * 0.5963326, size.height * 0.4997927);
    path_0.lineTo(size.width * 0.2222299, size.height * 0.8738953);
    path_0.cubicTo(
        size.width * 0.2119373,
        size.height * 0.8841961,
        size.width * 0.2062544,
        size.height * 0.8979277,
        size.width * 0.2062544,
        size.height * 0.9125698);
    path_0.cubicTo(
        size.width * 0.2062544,
        size.height * 0.9272282,
        size.width * 0.2119373,
        size.height * 0.9409598,
        size.width * 0.2222299,
        size.height * 0.9512687);
    path_0.lineTo(size.width * 0.2550020, size.height * 0.9840245);
    path_0.cubicTo(
        size.width * 0.2653027,
        size.height * 0.9943252,
        size.width * 0.2790343,
        size.height * 1.000000,
        size.width * 0.2936846,
        size.height * 1.000000);
    path_0.cubicTo(
        size.width * 0.3083349,
        size.height * 1.000000,
        size.width * 0.3220746,
        size.height * 0.9943252,
        size.width * 0.3323672,
        size.height * 0.9840245);
    path_0.lineTo(size.width * 0.7777945, size.height * 0.5386135);
    path_0.cubicTo(
        size.width * 0.7881115,
        size.height * 0.5282803,
        size.width * 0.7937781,
        size.height * 0.5144836,
        size.width * 0.7937456,
        size.height * 0.4998171);
    path_0.cubicTo(
        size.width * 0.7937781,
        size.height * 0.4850936,
        size.width * 0.7881115,
        size.height * 0.4713051,
        size.width * 0.7777945,
        size.height * 0.4609800);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class XButtonPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9980833, size.height * 0.8762500);
    path_0.lineTo(size.width * 0.6154167, size.height * 0.4972917);
    path_0.lineTo(size.width * 0.9942500, size.height * 0.1150417);
    path_0.lineTo(size.width * 0.8762500, size.height * -0.001916667);
    path_0.lineTo(size.width * 0.4975000, size.height * 0.3805417);
    path_0.lineTo(size.width * 0.1151667, size.height * 0.001875000);
    path_0.lineTo(size.width * -0.001916667, size.height * 0.1189583);
    path_0.lineTo(size.width * 0.3808333, size.height * 0.4983333);
    path_0.lineTo(size.width * 0.001875000, size.height * 0.8810000);
    path_0.lineTo(size.width * 0.1189583, size.height * 0.9980833);
    path_0.lineTo(size.width * 0.4986250, size.height * 0.6150833);
    path_0.lineTo(size.width * 0.8811250, size.height * 0.9942500);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xff999999).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class BottomBorderBox extends CustomPainter {
  final Animation<double> _animation;
  Color bgColor;
  BottomBorderBox(this._animation, this.bgColor) : super(repaint: _animation);

  Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    // ComputeMetrics can only be iterated once!
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = new Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        // There might be a more efficient way of extracting an entire path
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }
    return path;
  }

  Path _createAnyPath(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, Radius.circular(size.width)));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = _animation.value;

    Paint border = Paint()
      ..strokeWidth = 3
      ..color = bgColor
      ..style = PaintingStyle.stroke;

    final path = createAnimatedPath(_createAnyPath(size), animationPercent);

    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
