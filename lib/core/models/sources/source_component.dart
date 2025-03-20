import 'package:circuit_solver/core/models/component.dart';

abstract class SourceComponent extends Component {
  SourceComponent({
    super.id,
    required super.name,
    required super.symbol,
    required super.width,
    required super.height,
  });
}
