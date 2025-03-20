import 'dart:math' show atan2, sqrt;

import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';

class GridComponent {
  final Component component;
  Coordinate startCoordinate;
  Coordinate endCoordinate;

  double get rotation => atan2(
        endCoordinate.y - startCoordinate.y,
        endCoordinate.x - startCoordinate.x,
      );

  double get length => sqrt(
        (endCoordinate.x - startCoordinate.x) *
                (endCoordinate.x - startCoordinate.x) +
            (endCoordinate.y - startCoordinate.y) *
                (endCoordinate.y - startCoordinate.y),
      );

  GridComponent({
    required this.component,
    required this.startCoordinate,
    required this.endCoordinate,
  });

  double get top {
    return component is Wire ? startCoordinate.y - 1 : startCoordinate.y - 8;
  }
}
