import 'package:flutter/material.dart';

class ImplicitAnimation extends StatefulWidget {
  const ImplicitAnimation({super.key});

  @override
  State<ImplicitAnimation> createState() => _ImplicitAnimationState();
}

class _ImplicitAnimationState extends State<ImplicitAnimation> {
  var _width = 100.0;
  var _isZoomed = false;
  var _title = "Zoom In";
  var _curves = Curves.bounceInOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(
                milliseconds: 370,
              ),
              width: _width,
              curve: _curves,
              child: Image.asset('assets/images/images.jpeg', fit: BoxFit.fitWidth,),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isZoomed = !_isZoomed;
                  _title = _isZoomed ? "Zoom Out" : "Zoom In";
                  _width = _isZoomed ? MediaQuery.of(context).size.width : 100;
                  _curves = _isZoomed ? Curves.bounceOut : Curves.bounceIn;
                });
              },
              child: Text(_title),
            ),
          ],
        ),
      ),
    );
  }
}
