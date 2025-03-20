import 'package:circuit_solver/features/toolbox/providers/toolbox_notifier.dart';
import 'package:circuit_solver/features/toolbox/views/component_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Toolbox extends StatelessWidget {
  const Toolbox({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ToolboxNotifier(),
      builder: (context, _) {
        return Container(
          color: Colors.blueGrey[100],
          width: 250,
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: ToolboxComponent.values.map((component) {
              return ComponentButton(toolboxComponent: component);
            }).toList(),
          ),
        );
      },
    );
  }
}
