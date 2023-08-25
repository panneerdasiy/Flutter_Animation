import 'package:animation/anim/animated_alert.dart';
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
          child: AnimatedAlert(
            title: 'Thank You for your order!',
            subtitle: 'your order will be delivered in 2 days. Enjoy!',
            icon: Icons.cancel,
          ),
        ),
      ),
    );
  }
}
