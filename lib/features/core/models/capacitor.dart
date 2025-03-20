import 'package:circuit_solver/features/core/models/passive_component.dart';

class Capacitor extends PassiveComponent {
  final double capacitance;

  const Capacitor({
    required super.id,
    required this.capacitance,
  }) : super(name: 'Capacitor', image: 'capacitor.png', symbol: 'C');
}
