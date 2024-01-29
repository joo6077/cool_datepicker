import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MonthAnimation implements TickerProvider {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // getter
  AnimationController get controller => _controller;
  Animation<double> get animation => _animation;

  MonthAnimation({
    required int duration,
  }) {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  // forward
  void forward() {
    _controller.forward();
  }

  // reverse
  void reverse() {
    _controller.reverse();
  }

  // dispose
  void dispose() {
    _controller.dispose();
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }
}
