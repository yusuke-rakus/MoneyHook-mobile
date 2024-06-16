import 'package:flutter/material.dart';

AlertDialog commonConfirmDialog({
  required BuildContext context,
  required String title,
  String? subTitle,
  required String leftText,
  required String rightText,
  required Function primaryFunction,
  Function? secondaryFunction,
}) {
  return AlertDialog(
    title: Text(title, style: const TextStyle(fontSize: 18)),
    content: subTitle != null ? Text(subTitle) : null,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0))),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
            secondaryFunction?.call();
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
          child: Text(leftText)),
      TextButton(
          onPressed: () => primaryFunction(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0))),
          ),
          child: Text(rightText)),
    ],
  );
}
