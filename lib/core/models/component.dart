abstract class Component {
  final String id;
  final String name;
  final String symbol;
  final String? image;

  const Component({
    required this.id,
    required this.name,
    required this.symbol,
    this.image,
  });
}
