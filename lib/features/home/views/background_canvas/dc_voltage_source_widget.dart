import 'dart:math' show pi;

import 'package:circuit_solver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class DCVoltageSourceWidget extends StatelessWidget {
  const DCVoltageSourceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Row(
          children: [
            Container(
              height: constraints.maxHeight*2/3,
              width: 2,
              color: Colors.black,
            ),
            const Spacer(),
            Container(
              width: 2,
              color: Colors.black,
            ),
          ],
        );
      },
    );
  }
}
