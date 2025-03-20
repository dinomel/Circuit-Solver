import 'package:flutter/material.dart';

class ResistorWidget extends StatelessWidget {
  final double length;

  const ResistorWidget({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              color: Colors.black,
            ),
          ),
          Container(
            height: 16,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
