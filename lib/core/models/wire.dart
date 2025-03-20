import 'package:circuit_solver/core/models/component.dart';

class Wire extends Component {
  Wire({super.id})
      : super(
          name: 'Wire',
          symbol: 'W',
          width: 0,
          height: 2,
        );
}
