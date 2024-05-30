import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double borderRadius;

  GradientButton(
      {required this.onPressed, this.borderRadius = 8, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blueAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: onPressed == null ? const Color(0xFFD3D3D3) : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
