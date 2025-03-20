import 'package:circuit_solver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class ResistorWidget extends StatelessWidget {
  final double length;

  const ResistorWidget({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    const double width = Constants.gridSize * 5 / 2;
    return SizedBox(
      width: length,
      child: Row(
        children: [
          Container(
            height: 2,
            width: (length - width) / 2 < 0 ? 4 : (length - width) / 2,
            color: Colors.black,
          ),
          Flexible(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
          Container(
            height: 2,
            width: (length - width) / 2 < 0 ? 4 : (length - width) / 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
