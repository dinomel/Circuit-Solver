import 'dart:math' show atan2, sqrt;

import 'package:circuit_solver/core/constants/constants.dart';
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

  double get distance => sqrt(
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

  double get top =>
      Constants.gridSize * startCoordinate.y - (component is Wire ? 1 : 8);

  double get left => Constants.gridSize * startCoordinate.x * 1;
}
