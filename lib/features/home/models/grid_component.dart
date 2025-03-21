import 'dart:math' show atan2, sqrt;

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
}
