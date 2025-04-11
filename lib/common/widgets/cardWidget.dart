import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;

  const CardWidget({
    super.key,
    this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
      margin: margin,
      child: child,
    );
  }
}
