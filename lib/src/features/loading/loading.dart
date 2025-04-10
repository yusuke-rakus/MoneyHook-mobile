import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_hooks/src/common/widgets/commonLoadingAnimation.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            height: 120,
            child: Image.asset(
              "images/color_logo.png",
              fit: BoxFit.contain,
            )),
        CommonLoadingAnimation.build(),
      ],
    ));
  }
}
