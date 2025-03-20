import 'package:circuit_solver/core/models/sources/source_component.dart';

class ACVoltageSource extends SourceComponent {
  final double frequency;

  ACVoltageSource({
    super.id,
    this.frequency = 50,
    required super.width,
    required super.height,
  }) : super(
          name: 'AC Voltage Source',
          image: 'ac_voltage_source.png',
          symbol: 'V',
        );
}
