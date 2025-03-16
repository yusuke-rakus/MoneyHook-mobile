import 'package:flutter/material.dart';
import 'package:money_hooks/src/env/AppTextStyle.dart';
import 'package:money_hooks/src/env/envClass.dart';

class AppBarMonth extends StatefulWidget {
  final Function subtractMonth;
  final Function addMonth;
  final envClass env;
  final double? titleFontSize;

  AppBarMonth({
    required this.subtractMonth,
    required this.addMonth,
    required this.env,
    this.titleFontSize,
  });

  @override
  State<AppBarMonth> createState() => _CenterWidgetState();
}

class _CenterWidgetState extends State<AppBarMonth> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Tooltip(
          message: '前の月',
          child: IconButton(
              onPressed: () {
                widget.subtractMonth();
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        Text(
          '${widget.env.getMonth()}月',
          style: AppTextStyle(fontSize: widget.titleFontSize),
        ),
        Tooltip(
          message: '次の月',
          child: IconButton(
              onPressed: () {
                setState(() {
                  // 翌月が未来でなければデータ取得
                  if (widget.env.isNotCurrentMonth()) {
                    widget.addMonth();
                  }
                });
              },
              icon: const Icon(Icons.arrow_forward_ios)),
        ),
      ],
    );
  }
}
