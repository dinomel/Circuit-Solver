import 'dart:math' show pi;

import 'package:flutter/material.dart';

class ACVoltageSourceWidget extends StatelessWidget {
  final bool isSelected;

  const ACVoltageSourceWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.black,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: CustomPaint(
            painter: ACVoltageSourcePainter(
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 3,
            width: 3,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class ACVoltageSourcePainter extends CustomPainter {
  final Color color;

  ACVoltageSourcePainter({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
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
