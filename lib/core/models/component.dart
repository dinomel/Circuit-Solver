import 'package:uuid/uuid.dart' show Uuid;

abstract class Component {
  final String id;
  final String name;
  final String symbol;
  final String? image;
  final double width;
  final double height;

  Component({
    String? id,
    required this.name,
    required this.symbol,
    required this.width,
    required this.height,
    this.image,
  }) : id = id ?? const Uuid().v4();
}
