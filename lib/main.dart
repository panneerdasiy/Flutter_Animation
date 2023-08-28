import 'package:animation/anim/rotating_square.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Scaffold(
        body: Center(
          child: RotatingSquare(),
        ),
      ),
    );
  }
}
