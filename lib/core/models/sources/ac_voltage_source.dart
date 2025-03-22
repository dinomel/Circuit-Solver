import 'package:circuit_solver/core/constants/constants.dart';
import 'package:circuit_solver/core/models/sources/source_component.dart';

class ACVoltageSource extends SourceComponent {
  final double maxVoltage;
  final double frequency;

  ACVoltageSource({
    super.id,
    required this.maxVoltage,
    this.frequency = 50,
  }) : super(
          name: 'AC Voltage Source',
          image: 'ac_voltage_source.png',
          symbol: 'V',
          width: Constants.gridSize * 5 / 3,
          height: Constants.gridSize * 5 / 3,
        );
}
