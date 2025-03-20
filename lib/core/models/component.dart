abstract class Component {
  final String id;
  final String name;
  final String symbol;
  final String? image;
  final double width;
  final double height;

  const Component({
    required this.id,
    required this.name,
    required this.symbol,
    required this.width,
    required this.height,
    this.image,
  });
}
