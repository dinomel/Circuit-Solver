import 'package:circuit_solver/core/models/sources/source_component.dart';

class DCVoltageSource extends SourceComponent {
  DCVoltageSource({
    super.id,
    required super.width,
    required super.height,
  }) : super(
          name: 'DC Voltage Source',
          image: 'dc_voltage_source.png',
          symbol: 'V',
        );
}
