import 'package:flutter/cupertino.dart';

class Triangle extends CustomPainter{
  final Color backgroundColor;

  Triangle(this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;

    final path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}