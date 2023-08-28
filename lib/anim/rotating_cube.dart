import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class RotatingCube extends StatefulWidget {
  const RotatingCube({super.key});

  @override
  State<RotatingCube> createState() => _RotatingCubeState();
}

class _RotatingCubeState extends State<RotatingCube>
    with TickerProviderStateMixin {
  late AnimationController _xAnimationController;
  late AnimationController _yAnimationController;
  late AnimationController _zAnimationController;
  late Tween<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _xAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _yAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _zAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _rotationAnim = Tween<double>(begin: 0, end: 2 * pi);

    _xAnimationController.repeat();
    _yAnimationController.repeat();
    _zAnimationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _xAnimationController.dispose();
    _yAnimationController.dispose();
    _zAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _xAnimationController,
          _yAnimationController,
          _zAnimationController,
        ]),
        builder: (context, _) {
          return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_rotationAnim.evaluate(_xAnimationController))
                ..rotateY(_rotationAnim.evaluate(_yAnimationController))
                ..rotateZ(_rotationAnim.evaluate(_zAnimationController)),
              child: const Cube());
        });
  }
}

class Cube extends StatelessWidget {
  final double size = 100;

  const Cube({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform(
          transform: Matrix4.identity()..translate(Vector3(0, 0, size)),
          child: CubeSide(size: size, color: Colors.red),
        ),
        Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()..rotateY(pi / 2),
          child: CubeSide(size: size, color: Colors.blue),
        ),
        Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()..rotateY(-pi / 2),
          child: CubeSide(size: size, color: Colors.green),
        ),
        Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()..rotateX(-pi / 2),
          child: CubeSide(size: size, color: Colors.orange),
        ),
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()..rotateX(pi / 2),
          child: CubeSide(size: size, color: Colors.cyan),
        ),
        CubeSide(size: size, color: Colors.yellow),
      ],
    );
  }
}

class CubeSide extends StatelessWidget {
  final double size;
  final Color color;

  const CubeSide({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      color: color,
    );
  }
}
