import 'package:flutter/material.dart';
import 'package:cool_datepicker/enums/SelectType.dart';

class DateInfo {
  int? date;
  int? weekday;
  SelectType isSelected;
  AnimationController? singleSelectedAniCtrl;
  Animation<double>? singleScaleAnimation;

  DateInfo(
      {this.weekday,
      this.date,
      required this.isSelected,
      this.singleSelectedAniCtrl,
      this.singleScaleAnimation});
}
