import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/passive_components/passive_component.dart';

class Inductor extends PassiveComponent {
  final double inductance;

   Inductor({
     super.id,
    required this.inductance,
  }) : super(
          name: 'Inductor',
          image: 'inductor.png',
          symbol: 'L',
          width: Constants.gridSize * 5 / 2,
          height: Constants.gridSize * 5 / 6,
        );
}
