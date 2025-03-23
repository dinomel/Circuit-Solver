import 'dart:math' show atan2, sqrt;
import 'dart:ui';

import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';

class GridComponent {
  final Component component;
  Coordinate startCoordinate;
  Coordinate endCoordinate;
  bool isSelected;

  double get rotation => atan2(
        endCoordinate.y - startCoordinate.y,
        endCoordinate.x - startCoordinate.x,
      );

  double get distance => sqrt(
        (endCoordinate.x - startCoordinate.x) *
                (endCoordinate.x - startCoordinate.x) +
            (endCoordinate.y - startCoordinate.y) *
                (endCoordinate.y - startCoordinate.y),
      );

  double get top =>
      Constants.gridSize * startCoordinate.y - component.height / 2;

  double get left => Constants.gridSize * startCoordinate.x / 1;

  GridComponent({
    required this.component,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.isSelected,
  });

  double distanceToOffsetSquared(Offset pos) {
    final x0 = pos.dx;
    final y0 = pos.dy;
    final x1 = startCoordinate.x * Constants.gridSize;
    final y1 = startCoordinate.y * Constants.gridSize;
    final x2 = endCoordinate.x * Constants.gridSize;
    final y2 = endCoordinate.y * Constants.gridSize;

    final dx = x2 - x1;
    final dy = y2 - y1;

    double projected = ((x0 - x1) * dx + (y0 - y1) * dy) / (dx * dx + dy * dy);

    if (projected < 0) {
      return (x0 - x1) * (x0 - x1) + (y0 - y1) * (y0 - y1);
    } else if (projected > 1) {
      return (x0 - x2) * (x0 - x2) + (y0 - y2) * (y0 - y2);
    } else {
      double numeratorSqRoot = (dy * x0 - dx * y0 + (x2 * y1 - y2 * x1)).abs();
      double denominator = dy * dy + dx * dx * 1;
      return numeratorSqRoot * numeratorSqRoot / denominator;
    }
  }
}
