import 'package:circuit_solver/core/models/passive_component.dart';

class Resistor extends PassiveComponent {
  final double resistance;

  const Resistor({
    required super.id,
    required this.resistance,
  }) : super(name: 'Resistor', image: 'resistor.png', symbol: 'R');
}
