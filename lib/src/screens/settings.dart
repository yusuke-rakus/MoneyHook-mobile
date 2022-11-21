import "package:flutter/material.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: const Center(
        child: Text(
          "設定画面",
          style: TextStyle(fontSize: 32.0),
        ),
      ),
    );
  }
}
