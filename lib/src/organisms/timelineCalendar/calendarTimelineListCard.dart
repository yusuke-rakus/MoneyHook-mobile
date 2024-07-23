import 'package:flutter/material.dart';
import 'package:money_hooks/src/class/transactionClass.dart';
import 'package:money_hooks/src/components/centerWidget.dart';
import 'package:money_hooks/src/components/timelineList.dart';
import 'package:money_hooks/src/env/envClass.dart';

class CalendarTimelineListCard extends StatefulWidget {
  final envClass env;
  final List<TransactionClass> timelineList;
  final Function setReload;

  const CalendarTimelineListCard(
      {super.key,
      required this.env,
      required this.timelineList,
      required this.setReload});

  @override
  State<CalendarTimelineListCard> createState() =>
      _CalendarTimelineListCardState();
}

class _CalendarTimelineListCardState extends State<CalendarTimelineListCard> {
  @override
  Widget build(BuildContext context) {
    return CenterWidget(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const ListTile(
              title: Text(
                'タイムライン',
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              leading: Icon(Icons.show_chart),
            ),
            TimelineList(
                env: widget.env,
                timelineList: widget.timelineList,
                setReload: widget.setReload),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
