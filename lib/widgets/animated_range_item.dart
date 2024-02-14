import 'package:flutter/material.dart';

class AnimatedRangeBackgroundWidget extends StatefulWidget {
  final AnimationController controller;
  final Widget selectedItem;
  final Widget item;
  final VoidCallback? onTap;

  const AnimatedRangeBackgroundWidget({
    Key? key,
    required this.controller,
    required this.selectedItem,
    required this.item,
    required this.onTap,
  }) : super(key: key);
  @override
  AnimatedRangeBackgroundWidgetState createState() =>
      AnimatedRangeBackgroundWidgetState();
}

class AnimatedRangeBackgroundWidgetState
    extends State<AnimatedRangeBackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          widget.item,
          Positioned.fill(
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (_, child) {
                return Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: widget.controller.value,
                  heightFactor: widget.controller.value,
                  child: child,
                );
              },
              child: widget.selectedItem,
            ),
          ),
        ],
      ),
    );
  }
}
