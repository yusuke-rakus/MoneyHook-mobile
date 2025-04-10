import 'package:flutter/material.dart';

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    double x;
    double y;

    double width = scaffoldGeometry.scaffoldSize.width;
    if (width <= 1024) {
      x = width - 72.0;
      y = scaffoldGeometry.scaffoldSize.height - 72.0;
    } else {
      x = width / 2 + 410;
      y = scaffoldGeometry.scaffoldSize.height - 72.0;
    }
    return Offset(x, y);
  }
}
