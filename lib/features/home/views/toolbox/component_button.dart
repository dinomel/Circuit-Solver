import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComponentButton extends StatelessWidget {
  final ToolboxComponent toolboxComponent;

  const ComponentButton({
    super.key,
    required this.toolboxComponent,
  });

  @override
  Widget build(BuildContext context) {
    final homeNotifier = context.read<HomeNotifier>();
    return Selector<HomeNotifier, bool>(
      selector: (_, notifier) => notifier.selectedComponent == toolboxComponent,
      builder: (_, isSelected, __) {
        return Material(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => homeNotifier.selectComponent(toolboxComponent),
            child: Center(child: Text(toolboxComponent.name)),
          ),
        );
      },
    );
  }
}
