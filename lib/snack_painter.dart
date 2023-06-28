import 'package:flutter/material.dart';

class SnackPainter extends CustomPainter {
  // the positions of all the paths
  final List<Size> position = [];
  // radius of snack
  final radius = 10;
  //
  final color = const Color(0xFFFFFF00);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
