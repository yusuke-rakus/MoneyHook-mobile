import 'package:flutter/material.dart';
import 'package:money_hooks/src/common/widgets/centerWidget.dart';

class Imagelayer extends StatelessWidget {
  final bool firstVisible;

  const Imagelayer({super.key, required this.firstVisible});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E88E5), Color(0xFF64B5F6)]),
      ),
      child: Stack(children: [
        CenterWidget(
            child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: firstVisible ? 1.0 : 0.0,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                          height: 170,
                          child: Row(children: [
                            Image.asset('images/color_logo.png',
                                fit: BoxFit.contain),
                            Text('シンプル家計簿',
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white70))
                          ])),
                    )))),
        CenterWidget(
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                    width: 500,
                    height: 350,
                    margin: const EdgeInsets.only(top: 170),
                    child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        margin: EdgeInsets.only(right: firstVisible ? 20 : 0),
                        child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: firstVisible ? 1.0 : 0.0,
                            child: SizedBox(
                                width: 400,
                                height: 300,
                                child: Image.asset('images/pc-home.png',
                                    fit: BoxFit.contain))))))),
        CenterWidget(
            child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                    alignment: Alignment.centerRight,
                    width: 500,
                    height: 280,
                    margin: const EdgeInsets.only(top: 200),
                    child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        margin: EdgeInsets.only(right: firstVisible ? 20 : 0),
                        child: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: firstVisible ? 1.0 : 0.0,
                            child: SizedBox(
                                width: 200,
                                height: 280,
                                child: Image.asset('images/phone-home.png',
                                    fit: BoxFit.contain)))))))
      ]),
    );
  }
}
