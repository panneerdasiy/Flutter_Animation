import 'package:animation/rotating_and_flipping_circle.dart';
import 'package:animation/rotating_cube.dart';
import 'package:animation/rotating_square.dart';
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
      home: Scaffold(
        body: Center(
          child: RotatingCube(),
        ),
      ),
    );
  }
}
