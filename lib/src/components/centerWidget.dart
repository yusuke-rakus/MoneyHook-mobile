import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Alignment? alignment;
  final Color? color;

  CenterWidget({
    this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.alignment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: padding,
        margin: margin,
        height: height,
        width: width,
        alignment: alignment,
        color: color,
        child: child,
      ),
    );
  }
}
