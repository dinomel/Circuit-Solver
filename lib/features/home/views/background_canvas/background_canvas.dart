import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/grid_component_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackgroundCanvas extends StatelessWidget {
  const BackgroundCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final homeNotifier = context.read<HomeNotifier>();
    return Listener(
      onPointerDown: homeNotifier.onPointerDown,
      onPointerMove: homeNotifier.onPointerMove,
      onPointerUp: homeNotifier.onPointerUp,
      child: Container(
        color: Colors.white,
        child: Selector<HomeNotifier, List<GridComponent>>(
          selector: (_, notifier) => notifier.gridComponents,
          builder: (_, gridComponents, __) {
            return Stack(
              fit: StackFit.expand,
              children: gridComponents
                  .map(
                    (gridComponent) => GridComponentWidget(
                      gridComponent: gridComponent,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
      // child: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: Selector<HomeNotifier, Rect?>(
      //         selector: (_, notifier) => notifier.selectionRect,
      //         builder: (_, selectionRect, __) {
      //           return CustomPaint(
      //             painter: SelectionPainter(selectionRect),
      //           );
      //         },
      //       ),
      //     ),
      //   ],
      // ),
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
        ..color = Colors.blue.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect!, paint);

      final borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRect(rect!, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
