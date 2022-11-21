import "package:flutter/material.dart";

class VariableAnalysis extends StatefulWidget {
  const VariableAnalysis({super.key});

  @override
  State<VariableAnalysis> createState() => _VariableAnalysis();
}

class _VariableAnalysis extends State<VariableAnalysis> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          '変動費分析',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }
}
