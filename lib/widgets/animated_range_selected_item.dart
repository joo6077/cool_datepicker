import 'package:flutter/material.dart';

import 'package:cool_datepicker/enums/range_type.dart';

class AnimatedRangeSelectedItem extends StatefulWidget {
  final AnimationController dateController;
  final AnimationController rangeController;
  final Widget selectedItem;
  final Widget item;
  final Widget backgroundWidget;
  final VoidCallback? onTap;
  final RangeType rangeType;

  const AnimatedRangeSelectedItem({
    Key? key,
    required this.dateController,
    required this.rangeController,
    required this.selectedItem,
    required this.item,
    required this.backgroundWidget,
    required this.onTap,
    required this.rangeType,
  }) : super(key: key);
  @override
  AnimatedRangeSelectedItemState createState() =>
      AnimatedRangeSelectedItemState();
}

class AnimatedRangeSelectedItemState extends State<AnimatedRangeSelectedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          if (widget.rangeType == RangeType.range)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                    animation: widget.rangeController,
                    builder: (_, __) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: widget.rangeController.value,
                          child: widget.backgroundWidget,
                        ),
                      );
                    }),
              ),
            ),
          if (widget.rangeType == RangeType.start)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedBuilder(
                    animation: widget.rangeController,
                    builder: (_, __) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.centerRight,
                          widthFactor: widget.rangeController.value * 0.5,
                          child: widget.backgroundWidget,
                        ),
                      );
                    }),
              ),
            ),
          if (widget.rangeType == RangeType.end)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                    animation: widget.rangeController,
                    builder: (_, __) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          widthFactor: widget.rangeController.value * 0.5,
                          child: widget.backgroundWidget,
                        ),
                      );
                    }),
              ),
            ),
          widget.item,
          Positioned.fill(
            child: ScaleTransition(
                scale: CurvedAnimation(
                    parent: widget.dateController, curve: Curves.easeOutBack),
                child: widget.selectedItem),
          ),
        ],
      ),
    );
  }
}
