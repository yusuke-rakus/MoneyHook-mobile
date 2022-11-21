import "package:flutter/material.dart";

class FixedAnalysis extends StatefulWidget {
  const FixedAnalysis({super.key});

  @override
  State<FixedAnalysis> createState() => _FixedAnalysis();
}

class _FixedAnalysis extends State<FixedAnalysis> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '固定費分析',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
