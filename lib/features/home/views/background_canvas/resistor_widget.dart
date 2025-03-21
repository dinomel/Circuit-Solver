import 'package:flutter/material.dart';

class ResistorWidget extends StatelessWidget {
  final bool isSelected;

  const ResistorWidget({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.black,
          width: 2,
        ),
      ),
    );
  }
}
