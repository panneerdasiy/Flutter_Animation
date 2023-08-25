import 'dart:math' show pi;

import 'package:flutter/material.dart';

class Drawer3D extends StatefulWidget {
  const Drawer3D({super.key});

  @override
  State<Drawer3D> createState() => _Drawer3DState();
}

class _Drawer3DState extends State<Drawer3D> with TickerProviderStateMixin {
  late double _screenWidth;
  late double _dragWidth;

  late AnimationController _animationController;
  late Animation<double> _xTranslationAnimationDrawer;
  late Animation<double> _xTranslationAnimationSidePanel;
  late Animation<double> _yRotationAnimationDrawer;
  late Animation<double> _yRotationAnimationSidePanel;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    _dragWidth = _screenWidth * 0.7;

    _yRotationAnimationDrawer = Tween<double>(
      begin: 0,
      end: -pi / 2,
    ).animate(_animationController);

    _xTranslationAnimationDrawer = Tween<double>(
      begin: 0,
      end: _dragWidth,
    ).animate(_animationController);

    _yRotationAnimationSidePanel = Tween<double>(
      begin: pi / 2.7,
      end: 0,
    ).animate(_animationController);

    _xTranslationAnimationSidePanel = Tween<double>(
      begin: 0,
      end: _dragWidth,
    ).animate(_animationController);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        _animationController.value += details.delta.dx / _dragWidth;
      },
      onHorizontalDragEnd: (details) {
        if (_animationController.value >= 0.5) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_xTranslationAnimationDrawer]),
        builder: (context, _) {
          return Stack(
            children: [
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(_xTranslationAnimationDrawer.value)
                  ..rotateY(_yRotationAnimationDrawer.value),
                child: const Drawer(),
              ),
              Transform(
                alignment: Alignment.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(
                    -_screenWidth + _xTranslationAnimationSidePanel.value,
                  )
                  ..rotateY(_yRotationAnimationSidePanel.value),
                child: const SidePanel(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SidePanel extends StatelessWidget {
  const SidePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 130),
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (_, index) => Text('Item ${index + 1}'),
        ),
      ),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer'),
      ),
    );
  }
}
