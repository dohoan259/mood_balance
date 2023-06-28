import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path();
    path.moveTo(10, 50);

    for (int i = 0; i < 8; i++) {
      const c = 2;
      var delta = c;
      var x = 10.0 + i * 7;
      if (i % 2 == 1) {
        delta = -c;
      }

      path.lineTo(x, 50.0 + delta);
    }
    // path.quadraticBezierTo(
    //     size.width / 2, size.height, size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
