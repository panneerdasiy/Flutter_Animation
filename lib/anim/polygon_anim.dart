import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class PolygonAnim extends StatefulWidget {
  const PolygonAnim({super.key});

  @override
  State<PolygonAnim> createState() => _PolygonAnimState();
}

class _PolygonAnimState extends State<PolygonAnim>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    _initSidesAnimation();
    _initSizeAnimation();
    _initRotationAnimation();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _sidesController.repeat(reverse: true);
    _sizeController.repeat(reverse: true);
    _rotationController.repeat(reverse: true);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _sizeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // rotate
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _sidesController,
            _sizeController,
            _rotationController,
          ]),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_rotationAnimation.value)
                ..rotateY(_rotationAnimation.value)
                ..rotateZ(_rotationAnimation.value),
              child: CustomPaint(
                painter: PolygonPainter(sides: _sidesAnimation.value),
                child: SizedBox(
                  height: _sizeAnimation.value,
                  width: _sizeAnimation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _initSidesAnimation() {
    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _sidesAnimation = IntTween(begin: 3, end: 10).animate(_sidesController);
  }

  void _initSizeAnimation() {
    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _sizeAnimation = Tween<double>(begin: 50, end: 400)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(_sizeController);
  }

  void _initRotationAnimation() {
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi)
        .chain(CurveTween(curve: Curves.fastOutSlowIn))
        .animate(_rotationController);
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;

  const PolygonPainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getPolygonPath(size);
    final paint = _getPaint();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) => oldDelegate.sides != sides;

  Path _getPolygonPath(Size size) {
    final path = Path();

    final angle = 2 * pi / sides;
    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2.0;
    final center = Offset(radius, radius);

    path.moveTo(center.dx + radius * cos(0), center.dy + radius * sin(0));
    for (final angle in angles) {
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      path.lineTo(center.dx + x, center.dy + y);
    }
    path.close();

    return path;
  }

  Paint _getPaint() {
    return Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
  }
}
