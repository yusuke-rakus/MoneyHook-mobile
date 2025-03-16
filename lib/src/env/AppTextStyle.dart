import 'package:flutter/material.dart';

class AppTextStyle extends TextStyle {
  const AppTextStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) : super(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        );

  static TextStyle of(BuildContext context,
      {double? fontSize, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
        fontFamily: "MPLUS1p",
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight);
  }
}
