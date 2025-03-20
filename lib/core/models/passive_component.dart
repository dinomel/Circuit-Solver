import 'package:circuit_solver/core/models/component.dart';

abstract class PassiveComponent extends Component {
  const PassiveComponent({
    required super.id,
    required super.name,
    required super.symbol,
    required super.image,
    required super.width,
    required super.height,
  });
}
