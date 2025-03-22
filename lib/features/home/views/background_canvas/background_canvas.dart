import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/component_selector.dart';
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
      onPointerHover: homeNotifier.onPointerHover,
      child: Container(
        color: Colors.white,
        child: Selector<
            HomeNotifier,
            (
              List<GridComponent>,
              List<(Coordinate, int)>,
            )>(
          selector: (_, notifier) => (
            notifier.gridComponents,
            notifier.allNodes,
          ),
          builder: (_, data, __) {
            final gridComponents = data.$1;
            final coordinates = data.$2;
            return Stack(
              fit: StackFit.expand,
              children: [
                ...gridComponents.map(
                  (gridComponent) => GridComponentWidget(
                    gridComponent: gridComponent,
                  ),
                ),
                ...coordinates.map(
                  (coordinate) {
                    return Selector<HomeNotifier, bool>(
                      selector: (_, notifier) =>
                          notifier.hoveredCoordinate == coordinate.$1,
                      builder: (_, isSelected, __) {
                        return Positioned(
                          top: Constants.gridSize * coordinate.$1.y -
                              (isSelected ? 4 : 2),
                          left: Constants.gridSize * coordinate.$1.x -
                              (isSelected ? 4 : 2),
                          child: Container(
                            width: isSelected ? 8 : 4,
                            height: isSelected ? 8 : 4,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : coordinate.$2 == 1
                                      ? Colors.red
                                      : Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const ComponentSelector(),
              ],
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
