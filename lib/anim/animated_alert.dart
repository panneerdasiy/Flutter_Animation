import 'package:flutter/material.dart';

class AnimatedAlert extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AnimatedAlert({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  State<AnimatedAlert> createState() => _AnimatedAlertState();
}

class _AnimatedAlertState extends State<AnimatedAlert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _bgScaleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<Offset> _yAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bgScaleAnimation = Tween<double>(begin: 2, end: 0.25)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_animationController);

    _iconScaleAnimation =
        Tween<double>(begin: 1, end: 2).animate(_animationController);

    _yAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: const Offset(0, -0.15),
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 7,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: SlideTransition(
                position: _yAnimation,
                child: ScaleTransition(
                  scale: _bgScaleAnimation,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: ScaleTransition(
                      scale: _iconScaleAnimation,
                      child: Icon(widget.icon, size: 100, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
