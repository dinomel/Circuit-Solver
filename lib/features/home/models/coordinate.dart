import 'dart:ui' show Offset;

import 'package:circuit_solver/core/constants/constants.dart';

class Coordinate {
  final int x;
  final int y;

  const Coordinate({required this.x, required this.y});

  factory Coordinate.fromOffset(Offset offset) {
    const gridSize = Constants.gridSize;
    int left = offset.dx.floor() ~/ gridSize * gridSize;
    int top = offset.dy.floor() ~/ gridSize * gridSize;
    final topLeft = Coordinate(x: left, y: top);
    final topRight = Coordinate(x: left + gridSize, y: top);
    final bottomLeft = Coordinate(x: left, y: top + gridSize);
    final bottomRight = Coordinate(x: left + gridSize, y: top + gridSize);
    return [topLeft, topRight, bottomLeft, bottomRight].reduce(
      (a, b) => (a.x - offset.dx) * (a.x - offset.dx) +
                  (a.y - offset.dy) * (a.y - offset.dy) <
              (b.x - offset.dx) * (b.x - offset.dx) +
                  (b.y - offset.dy) * (b.y - offset.dy)
          ? a
          : b,
    );
  }

  @override
  String toString() {
    return 'Coordinate(x: $x, y: $y)';
  }
}
