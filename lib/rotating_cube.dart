import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'dart:math' show pi;

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
  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();

    _xAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    _yAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    _zAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation = Tween<double>(begin: 0, end: 2 * pi);

    _xAnimationController.repeat();
    _yAnimationController.repeat();
    _zAnimationController.repeat();
  }

  @override
  void dispose() {
    _xAnimationController.dispose();
    _yAnimationController.dispose();
    _zAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
        [
          _xAnimationController,
          _yAnimationController,
          _zAnimationController,
        ],
      ),
      builder: (context, _) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(_animation.evaluate(_xAnimationController))
            ..rotateY(_animation.evaluate(_yAnimationController))
            ..rotateZ(_animation.evaluate(_zAnimationController)),
          child: Cube(size: 100),
        );
      },
    );
  }
}

class Cube extends StatelessWidget {
  final double size;

  const Cube({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //back
        Square(size: size, color: Colors.yellow),
        //front
        Transform(
          transform: Matrix4.identity()
            ..translate(Vector3(0, 0, size)),
          child: Square(size: size, color: Colors.red),
        ),
        //left
        Transform(
          alignment: Alignment.centerLeft,
          transform: Matrix4.identity()
            ..rotateY(-pi / 2.0),
          child: Square(size: size, color: Colors.blue),
        ),
        //right
        Transform(
          alignment: Alignment.centerRight,
          transform: Matrix4.identity()
            ..rotateY(pi / 2.0),
          child: Square(size: size, color: Colors.green),
        ),
        //top
        Transform(
          alignment: Alignment.topCenter,
          transform: Matrix4.identity()
            ..rotateX(pi / 2.0),
          child: Square(size: size, color: Colors.cyan),
        ),
        //top
        Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..rotateX(-pi / 2.0),
          child: Square(size: size, color: Colors.pink),
        ),
      ],
    );
  }
}

class Square extends StatelessWidget {
  final double size;
  final Color color;

  const Square({
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
