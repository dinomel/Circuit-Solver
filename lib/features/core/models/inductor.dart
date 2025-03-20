import 'package:circuit_solver/features/core/models/passive_component.dart';

class Inductor extends PassiveComponent {
  final double inductance;

  const Inductor({
    required super.id,
    required this.inductance,
  }) : super(name: 'Inductor', image: 'inductor.png', symbol: 'L');
}
