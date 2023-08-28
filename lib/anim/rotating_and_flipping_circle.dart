import 'dart:math';

import 'package:flutter/material.dart';

class RotatingAndFlippingCircle extends StatefulWidget {
  const RotatingAndFlippingCircle({super.key});

  @override
  State<RotatingAndFlippingCircle> createState() =>
      _RotatingAndFlippingCircleState();
}

class _RotatingAndFlippingCircleState extends State<RotatingAndFlippingCircle>
    with TickerProviderStateMixin {
  late AnimationController _zAnimationController;
  late AnimationController _yAnimationController;

  Animation<double>? _zRotationAnimation;
  Animation<double>? _yRotationAnimation;

  @override
  void initState() {
    super.initState();
    _zAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _yAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _initZRotationAnim();
    _initYRotationAnim();

    _yRotationAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _initZRotationAnim();
        _zAnimationController
          ..reset()
          ..forward();
      }
    });

    _zRotationAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _initYRotationAnim();
        _yAnimationController
          ..reset()
          ..forward();
      }
    });

    _zAnimationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _zAnimationController.dispose();
    _yAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _zRotationAnimation,
          _yRotationAnimation,
        ]),
        builder: (context, _) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateZ(_zRotationAnimation!.value)
              ..rotateY(_yRotationAnimation!.value),
            child: Transform(
              transform: Matrix4.identity(),
              child: const Circle(),
            ),
          );
        });
  }

  void _initZRotationAnim() {
    final zBegin =
        _zRotationAnimation == null ? 0.0 : _zRotationAnimation!.value;
    final zEnd = zBegin - pi / 2.0;

    _zRotationAnimation = Tween<double>(begin: zBegin, end: zEnd)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_zAnimationController);
  }

  void _initYRotationAnim() {
    final yBegin =
        _yRotationAnimation == null ? 0.0 : _yRotationAnimation!.value;
    final yEnd = yBegin - pi;

    _yRotationAnimation = Tween<double>(begin: yBegin, end: yEnd)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_yAnimationController);
  }
}

class Circle extends StatelessWidget {
  const Circle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: HalfCircleClipper(startAngle: pi / 2.0, sweepAngle: pi),
          child: Container(
            height: 200,
            width: 200,
            color: Colors.yellow,
          ),
        ),
        ClipPath(
          clipper: HalfCircleClipper(startAngle: 3 * pi / 2.0, sweepAngle: pi),
          child: Container(
            height: 200,
            width: 200,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final double startAngle;
  final double sweepAngle;

  HalfCircleClipper({required this.startAngle, required this.sweepAngle});

  @override
  Path getClip(Size size) {
    final path = Path();
    final oval = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addArc(oval, startAngle, sweepAngle);
    return path;
  }

  @override
  bool shouldReclip(HalfCircleClipper oldClipper) {
    return oldClipper.startAngle != startAngle ||
        oldClipper.sweepAngle != sweepAngle;
  }
}
