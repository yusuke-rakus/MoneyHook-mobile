import "package:flutter/material.dart";

class SavingList extends StatefulWidget {
  const SavingList({super.key});

  @override
  State<SavingList> createState() => _SavingList();
}

class _SavingList extends State<SavingList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '貯金一覧',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }
}
