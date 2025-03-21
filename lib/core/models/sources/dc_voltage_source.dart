import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/sources/source_component.dart';

class DCVoltageSource extends SourceComponent {
  final double voltage;

  DCVoltageSource({super.id, required this.voltage})
      : super(
          name: 'DC Voltage Source',
          image: 'dc_voltage_source.png',
          symbol: 'V',
          width: Constants.gridSize * 5 / 8,
          height: Constants.gridSize * 5 / 3,
        );
}
