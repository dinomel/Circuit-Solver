import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/passive_components/passive_component.dart';

class Resistor extends PassiveComponent {
  final double resistance;

  Resistor({
    super.id,
    required this.resistance,
  }) : super(
          name: 'Resistor',
          image: 'resistor.png',
          symbol: 'R',
          width: Constants.gridSize * 5 / 2,
          height: Constants.gridSize * 5 / 6,
        );
}
