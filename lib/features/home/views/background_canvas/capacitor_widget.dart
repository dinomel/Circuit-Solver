import 'package:flutter/material.dart';

class CapacitorWidget extends StatelessWidget {
  final bool isSelected;

  const CapacitorWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: isSelected ? Colors.blue : Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
}
