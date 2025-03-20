import 'package:flutter/material.dart';

class CapacitorWidget extends StatelessWidget {
  const CapacitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
    );
  }
}
