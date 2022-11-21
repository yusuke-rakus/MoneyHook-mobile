import "package:flutter/material.dart";

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("タイムライン"),
      ),
      body: const Center(
        child: Text(
          "タイムライン画面",
          style: TextStyle(fontSize: 32.0),
        ),
      ),
    );
  }
}
