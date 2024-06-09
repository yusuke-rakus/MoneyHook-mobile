import 'package:flutter/material.dart';

class CommonSnackBar {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> build(
      {required BuildContext context, required String text}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      width: 350,
    ));
  }
}
