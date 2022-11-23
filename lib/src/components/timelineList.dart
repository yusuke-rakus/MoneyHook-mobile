import 'package:flutter/material.dart';

class TimelineList extends StatefulWidget {
  const TimelineList({Key? key}) : super(key: key);
  final hej = 'Hej';

  @override
  State<TimelineList> createState() => _TimelineListState();
}

class _TimelineListState extends State<TimelineList> {

  late String hej;
  @override
  void initState() {
    super.initState();
    hej = widget.hej;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Container(
          height: 55,
          color: Colors.red,
          child: Text(hej),
        ),
        Container(
          height: 55,
          color: Colors.blue,
        ),
        Container(
          height: 55,
          color: Colors.red,
        ),
        Container(
          height: 55,
          color: Colors.blue,
        ),
        Container(
          height: 55,
          color: Colors.red,
        ),
        Container(
          height: 55,
          color: Colors.blue,
        ),
        Container(
          height: 55,
          color: Colors.red,
        ),
        Container(
          height: 55,
          color: Colors.blue,
        ),
        Container(
          height: 55,
          color: Colors.red,
        ),
      ],
    );
  }
}
