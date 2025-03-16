import 'package:flutter/material.dart';

class AppTextStyle extends TextStyle {
  const AppTextStyle(
      {double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      double? letterSpacing})
      : super(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing);

  static TextStyle of(BuildContext context,
      {double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return TextStyle(
        fontFamily: "MPLUS1p",
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing);
  }
}
