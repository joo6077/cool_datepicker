import 'package:flutter/material.dart';

class AnimatedSelectedItem extends StatefulWidget {
  final AnimationController controller;
  final Widget selectedItem;
  final Widget item;
  final VoidCallback? onTap;

  const AnimatedSelectedItem({
    Key? key,
    required this.controller,
    required this.selectedItem,
    required this.item,
    required this.onTap,
  }) : super(key: key);
  @override
  AnimatedSelectedItemState createState() => AnimatedSelectedItemState();
}

class AnimatedSelectedItemState extends State<AnimatedSelectedItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          widget.item,
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (_, child) {
                    return Align(
                      alignment: Alignment.center,
                      widthFactor: widget.controller.value,
                      heightFactor: widget.controller.value,
                      child: child,
                    );
                  },
                  child: widget.selectedItem,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
