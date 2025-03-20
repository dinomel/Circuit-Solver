import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/passive_components/passive_component.dart';

class Capacitor extends PassiveComponent {
  final double capacitance;

  Capacitor({
    super.id,
    required this.capacitance,
  }) : super(
          name: 'Capacitor',
          image: 'capacitor.png',
          symbol: 'C',
          width: Constants.gridSize * 5 / 8,
          height: Constants.gridSize * 5 / 3,
        );
}
