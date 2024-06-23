import 'package:flutter/material.dart';

class CenterWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Alignment? alignment;
  final Color? color;
  final double maxWidth;

  CenterWidget({
    this.child,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.alignment,
    this.color,
    this.maxWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
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
