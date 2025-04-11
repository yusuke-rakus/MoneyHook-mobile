import 'package:flutter/material.dart';

class DataNotRegisteredBox extends StatelessWidget {
  const DataNotRegisteredBox({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      child: Center(
          child: Column(children: [
        SizedBox(
          height: 70,
          child: Image.asset(
            "images/sub_logo.png",
            fit: BoxFit.contain,
          ),
        ),
        Text(message)
      ])),
    );
  }
}
