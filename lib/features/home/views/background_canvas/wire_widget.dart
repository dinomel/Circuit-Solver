import 'package:flutter/material.dart';

class WireWidget extends StatelessWidget {
  final double length;

  const WireWidget({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: length,
      height: 2,
      color: Colors.black,
    );
  }
}
