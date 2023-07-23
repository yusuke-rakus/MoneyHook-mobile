import 'package:flutter/material.dart';

Future<void> commonLoadingDialog({required BuildContext context}) async {
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return WillPopScope(
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          onWillPop: () async => false,
        );
      });
}
