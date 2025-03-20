import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/passive_components/capacitor.dart';
import 'package:circuit_solver/core/models/passive_components/inductor.dart';
import 'package:circuit_solver/core/models/passive_components/resistor.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/capacitor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/inductor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/resistor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/wire_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridComponentWidget extends StatelessWidget {
  final GridComponent gridComponent;

  const GridComponentWidget({super.key, required this.gridComponent});

  Widget _buildSpecificComponent() {
    final length = Constants.gridSize * gridComponent.distance;
    final width = gridComponent.component.width;
    final height = gridComponent.component.height;

    Widget widget;

    switch (gridComponent.component) {
      case Resistor():
        widget = const ResistorWidget();
      case Capacitor():
        widget = const CapacitorWidget();
      case Inductor():
        widget = const InductorWidget();
      default:
        widget = WireWidget(length: length);
    }

    return SizedBox(
      width: length,
      child: Row(
        children: [
          Container(
            height: 2,
            width: length < width ? 4 : (length - width) / 2,
            color: Colors.black,
          ),
          Expanded(
            child: SizedBox(
              height: height,
              child: widget,
            ),
          ),
          Container(
            height: 2,
            width: length < width ? 4 : (length - width) / 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: gridComponent.top,
      left: gridComponent.left,
      child: Selector<HomeNotifier, (double, double)>(
        selector: (_, __) => (gridComponent.rotation, gridComponent.distance),
        builder: (_, data, __) {
          final rotation = data.$1;
          final distance = data.$2;
          return Transform.rotate(
            angle: rotation,
            alignment: Alignment.centerLeft,
            child: gridComponent.component is Wire
                ? WireWidget(length: Constants.gridSize * distance)
                : _buildSpecificComponent(),
          );
        },
      ),
    );
  }
}
