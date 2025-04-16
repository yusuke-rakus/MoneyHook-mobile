import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CommonLoadingAnimation {
  static Widget build() {
    return LoadingAnimationWidget.waveDots(
        color: const Color(0xFF76D5FF), size: 50);
  }
}
