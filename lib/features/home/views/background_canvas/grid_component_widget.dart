import 'package:circuit_solver/core/models/capacitor.dart';
import 'package:circuit_solver/core/models/inductor.dart';
import 'package:circuit_solver/core/models/resistor.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/resistor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/wire_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridComponentWidget extends StatelessWidget {
  final GridComponent gridComponent;

  const GridComponentWidget({super.key, required this.gridComponent});

  Widget _buildSpecificComponent(double length) {
    switch (gridComponent.component) {
      case Wire():
        return WireWidget(length: length);
      case Resistor():
        return ResistorWidget(length: length);
      case Inductor():
        return const SizedBox();
      case Capacitor():
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: gridComponent.top,
      left: gridComponent.startCoordinate.x.toDouble(),
      child: Selector<HomeNotifier, (double, double)>(
        selector: (_, __) => (gridComponent.rotation, gridComponent.length),
        builder: (_, data, __) {
          final rotation = data.$1;
          final length = data.$2;
          return Transform.rotate(
            angle: rotation,
            alignment: Alignment.centerLeft,
            child: _buildSpecificComponent(length),
          );
        },
      ),
    );
  }
}
