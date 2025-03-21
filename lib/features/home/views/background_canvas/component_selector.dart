import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentSelector extends StatelessWidget {
  const ComponentSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Selector<HomeNotifier, Rect?>(
        selector: (_, notifier) => notifier.selectionRect,
        builder: (_, selectionRect, __) {
          return CustomPaint(
            painter: SelectionPainter(selectionRect),
          );
        },
      ),
    );
  }
}

class SelectionPainter extends CustomPainter {
  final Rect? rect;

  SelectionPainter(this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    if (rect != null) {
      final paint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect!, paint);

      final borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(rect!, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
