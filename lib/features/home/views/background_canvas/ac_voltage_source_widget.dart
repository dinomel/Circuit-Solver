import 'dart:math' show pi;

import 'package:circuit_solver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class ACVoltageSourceWidget extends StatelessWidget {
  const ACVoltageSourceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: CustomPaint(painter: ACVoltageSourcePainter()),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: Text(
            '*',
            style: TextStyle(
              height: 0.4,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class ACVoltageSourcePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect1 = Rect.fromLTWH(0, 0, size.width / 2, size.height);
    final rect2 = Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height);

    canvas.drawArc(rect1, 0, -pi, false, paint);
    canvas.drawArc(rect2, 0, pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
