import 'package:flutter/material.dart';
import 'package:money_hooks/class/transactionClass.dart';
import 'package:money_hooks/common/widgets/cardWidget.dart';
import 'package:money_hooks/common/widgets/centerWidget.dart';
import 'package:money_hooks/common/env/envClass.dart';
import 'package:money_hooks/features/timeline/timelineList.dart';

class CalendarTimelineListCard extends StatefulWidget {
  final EnvClass env;
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
      child: CardWidget(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
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
