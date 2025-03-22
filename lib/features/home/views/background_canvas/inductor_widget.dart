import 'dart:math' show pi;

import 'package:circuit_solver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class InductorWidget extends StatelessWidget {
  final bool isSelected;

  const InductorWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: InductorPainter(
        color: isSelected ? Colors.blue : Colors.black,
      ),
    );
  }
}

class InductorPainter extends CustomPainter {
  final Color color;

  InductorPainter({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rectangles = size.width < Constants.gridSize * 5 / 2
        ? [
            Rect.fromLTWH(0, 0, size.width / 2, size.height),
            Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height),
          ]
        : [
            Rect.fromLTWH(0, 0, size.width / 3, size.height),
            Rect.fromLTWH(size.width / 3, 0, size.width / 3, size.height),
            Rect.fromLTWH(2 * size.width / 3, 0, size.width / 3, size.height),
          ];

    for (final rect in rectangles) {
      canvas.drawArc(rect, 0, pi, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
