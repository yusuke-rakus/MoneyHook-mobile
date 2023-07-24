import 'package:flutter/cupertino.dart';

CupertinoAlertDialog deleteConfirmDialog({
  required BuildContext context,
  required String title,
  String? subTitle,
  required String leftText,
  required String rightText,
  bool? isDefaultAction,
  bool? isDestructiveAction,
  required Function function,
}) {
  return CupertinoAlertDialog(
      title: Text(title),
      content: subTitle != null ? Text(subTitle) : null,
      actions: [
        CupertinoDialogAction(
            onPressed: () {
              // キャンセル処理
              Navigator.pop(context);
            },
            child: Text(leftText)),
        CupertinoDialogAction(
            isDefaultAction: isDefaultAction ?? false,
            isDestructiveAction: isDestructiveAction ?? false,
            onPressed: () => function(),
            child: Text(rightText))
      ]);
}
