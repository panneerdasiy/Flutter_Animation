import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChangingCircleColor extends StatefulWidget {
  const ChangingCircleColor({super.key});

  @override
  State<ChangingCircleColor> createState() => _ChangingCircleColorState();
}

class _ChangingCircleColorState extends State<ChangingCircleColor> {
  var _color = getRandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CirclePathClipper(),
          child: TweenAnimationBuilder(
            duration: Duration(seconds: 1),
            tween: ColorTween(begin: getRandomColor(), end: _color),
            onEnd: () {
              setState(() {
                _color = getRandomColor();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              color: Colors.brown,
            ),
            builder: (context, Color? value, child) {
              return ColorFiltered(
                colorFilter: ColorFilter.mode(
                  _color,
                  BlendMode.srcOver,
                ),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }

  static Color getRandomColor() =>
      Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));
}

class CirclePathClipper extends CustomClipper<Path> {
  const CirclePathClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2.0, size.height / 2.0),
      radius: size.width / 2.0,
    );
    path.addOval(rect);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
