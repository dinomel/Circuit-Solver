import 'dart:math' show atan2;

import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';

class GridComponent {
  final Component component;
  Coordinate startCoordinate;
  Coordinate endCoordinate;

  double get rotation => atan2(
        endCoordinate.y - startCoordinate.y,
        endCoordinate.x - startCoordinate.x,
      );

  GridComponent({
    required this.component,
    required this.startCoordinate,
    required this.endCoordinate,
  });
}
