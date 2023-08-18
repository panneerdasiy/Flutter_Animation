import 'dart:math' show pi;

import 'package:flutter/material.dart';

class RotatingAndFlippingCircle extends StatefulWidget {
  const RotatingAndFlippingCircle({
    super.key,
  });

  @override
  State<RotatingAndFlippingCircle> createState() =>
      _RotatingAndFlippingCircleState();
}

class _RotatingAndFlippingCircleState extends State<RotatingAndFlippingCircle>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    _rotationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _setRotationAnimation(begin: 0, end: -pi / 2);

    _flipController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _setFlipAnimation(begin: 0, end: pi);

    _rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimate();
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotateAnimate();
      }
    });

    _rotationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, _) {
        return AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, _) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_rotationAnimation.value),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(_flipAnimation.value),
                  child: const TwoHalfCircles(),
                ),
              );
            });
      },
    );
  }

  void _flipAnimate() {
    _setFlipAnimation(
      begin: _flipAnimation.value,
      end: _flipAnimation.value - pi,
    );

    _flipController
      ..reset()
      ..forward();
  }

  void _rotateAnimate() {
    _setRotationAnimation(
      begin: _rotationAnimation.value,
      end: _rotationAnimation.value - pi / 2,
    );

    _rotationController
      ..reset()
      ..forward();
  }

  void _setRotationAnimation({required double begin, required double end}) {
    _rotationAnimation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  void _setFlipAnimation({required double begin, required double end}) {
    _flipAnimation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );
  }
}

class TwoHalfCircles extends StatelessWidget {
  const TwoHalfCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: const LinearGradient(
          colors: [Colors.yellow, Colors.blue],
          stops: [0.5, 0.5],
        ),
      ),
    );
  }
}
