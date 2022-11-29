import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Container(
              color: Colors.amber,
              height: 50,
              width: double.infinity,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  fixedSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  '登録',
                  style: TextStyle(fontSize: 23, letterSpacing: 20),
                ),
              ),
            ),
          ),
        )
      ],
    )
      ;
  }
}
