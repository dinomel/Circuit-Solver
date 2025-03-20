import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridComponentContainer extends StatelessWidget {
  final GridComponent gridComponent;

  const GridComponentContainer({super.key, required this.gridComponent});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: gridComponent.startCoordinate.y.toDouble(),
      left: gridComponent.startCoordinate.x.toDouble(),
      child: Selector<HomeNotifier, (double, double)>(
        selector: (_, __) => (gridComponent.rotation, gridComponent.length),
        builder: (_, data, __) {
          final rotation = data.$1;
          final length = data.$2;
          return Transform.rotate(
            angle: rotation,
            alignment: Alignment.centerLeft,
            child: Container(
              width: length,
              height: 2,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}
