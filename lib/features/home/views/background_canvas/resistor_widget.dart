import 'package:flutter/material.dart';

class ResistorWidget extends StatelessWidget {
  const ResistorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
    );
  }
}
