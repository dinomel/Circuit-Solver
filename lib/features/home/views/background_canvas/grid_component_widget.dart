import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/passive_components/capacitor.dart';
import 'package:circuit_solver/core/models/passive_components/inductor.dart';
import 'package:circuit_solver/core/models/passive_components/resistor.dart';
import 'package:circuit_solver/core/models/sources/ac_voltage_source.dart';
import 'package:circuit_solver/core/models/sources/dc_voltage_source.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/ac_voltage_source_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/capacitor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/dc_voltage_source_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/inductor_widget.dart';
import 'package:circuit_solver/features/home/views/background_canvas/resistor_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridComponentWidget extends StatelessWidget {
  final GridComponent gridComponent;

  const GridComponentWidget({
    super.key,
    required this.gridComponent,
  });

  Widget _buildSpecificComponent(bool isHovered) {
    final length = Constants.gridSize * gridComponent.distance;
    final width = gridComponent.component.width;
    final height = gridComponent.component.height;
    final isSelected = gridComponent.isSelected || isHovered;

    Widget widget = switch (gridComponent.component) {
      Resistor() => ResistorWidget(isSelected: isSelected),
      Capacitor() => CapacitorWidget(isSelected: isSelected),
      Inductor() => InductorWidget(isSelected: isSelected),
      ACVoltageSource() => ACVoltageSourceWidget(isSelected: isSelected),
      DCVoltageSource() => DCVoltageSourceWidget(isSelected: isSelected),
      _ => const SizedBox()
    };

    return SizedBox(
      width: length,
      child: Row(
        children: [
          Container(
            height: 2,
            width: length < width ? 4 : (length - width) / 2,
            color: isSelected ? Colors.blue : Colors.black,
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
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomeNotifier, (double, double, double, double, bool)>(
      selector: (_, notifier) => (
        gridComponent.rotation,
        gridComponent.distance,
        gridComponent.top,
        gridComponent.left,
        notifier.hoveredGridComponent == gridComponent,
      ),
      builder: (_, data, __) {
        final rotation = data.$1;
        final top = data.$3;
        final left = data.$4;
        final isHovered = data.$5;
        return Positioned(
          top: top,
          left: left,
          child: Transform.rotate(
            angle: rotation,
            alignment: Alignment.centerLeft,
            child: _buildSpecificComponent(isHovered),
          ),
        );
      },
    );
  }
}
