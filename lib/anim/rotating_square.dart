import 'dart:math';

import 'package:flutter/material.dart';

class RotatingSquare extends StatefulWidget {
  const RotatingSquare({super.key});

  @override
  State<RotatingSquare> createState() => _RotatingSquareState();
}

class _RotatingSquareState extends State<RotatingSquare>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      _animationController,
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, _) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateY(_rotationAnimation.value),
            child: const Square(),
          );
        });
  }
}

class Square extends StatelessWidget {
  const Square({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.cyan,
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 0),
              blurRadius: 10,
              spreadRadius: 6,
            )
          ]),
    );
  }
}
