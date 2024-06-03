import 'package:flutter/material.dart';

class GradientBar extends StatelessWidget {
  final Widget? child;

  GradientBar({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.lightBlue,
              Colors.blueAccent,
            ]),
      ),
      child: child,
    );
  }
}
