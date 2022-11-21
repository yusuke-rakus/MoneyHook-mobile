import "package:flutter/material.dart";

class TotalSaving extends StatefulWidget {
  const TotalSaving({super.key});

  @override
  State<TotalSaving> createState() => _TotalSaving();
}

class _TotalSaving extends State<TotalSaving> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '貯金総額',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
