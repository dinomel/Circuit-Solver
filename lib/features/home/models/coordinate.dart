import 'dart:ui' show Offset;

import 'package:circuit_solver/core/constants/constants.dart';

class Coordinate {
  final int x;
  final int y;

  const Coordinate({required this.x, required this.y});

  factory Coordinate.fromOffset(Offset offset) {
    const gridSize = Constants.gridSize;
    int left = offset.dx.floor() ~/ gridSize;
    int top = offset.dy.floor() ~/ gridSize;
    final topLeft = Coordinate(x: left, y: top);
    final topRight = Coordinate(x: left + 1, y: top);
    final bottomLeft = Coordinate(x: left, y: top + 1);
    final bottomRight = Coordinate(x: left + 1, y: top + 1);
    return [topLeft, topRight, bottomLeft, bottomRight].reduce(
      (a, b) => (a.x * gridSize - offset.dx) * (a.x * gridSize - offset.dx) +
                  (a.y * gridSize - offset.dy) * (a.y * gridSize - offset.dy) <
              (b.x * gridSize - offset.dx) * (b.x * gridSize - offset.dx) +
                  (b.y * gridSize - offset.dy) * (b.y * gridSize - offset.dy)
          ? a
          : b,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'Coordinate{x: $x, y: $y}';
  }

  Offset toOffset() {
    const gridSize = Constants.gridSize;
    return Offset(x * gridSize / 1, y * gridSize / 1);
  }
}
