import 'package:circuit_solver/core/models/passive_components/resistor.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/toolbox/component_button.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Toolbox extends StatelessWidget {
  const Toolbox({super.key});

  @override
  Widget build(BuildContext context) {
    final homeNotifier = context.read<HomeNotifier>();
    return Container(
      color: Colors.blueGrey[100],
      width: 250,
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: ToolboxComponent.values.map((component) {
              return ComponentButton(toolboxComponent: component);
            }).toList(),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Selector<HomeNotifier, List<GridComponent>>(
                selector: (_, notifier) =>
                    notifier.gridComponents.reversed.toList(),
                builder: (_, gridComponents, __) {
                  return ExpansionTileGroup(
                    toggleType: ToggleType.expandOnlyCurrent,
                    children: gridComponents.map(
                      (gridComponent) {
                        return ExpansionTileItem(
                          onExpansionChanged: (isExpanded) {
                            homeNotifier.selectOnlyThisGridComponent(
                              gridComponent: gridComponent,
                              isSelected: isExpanded,
                            );
                          },
                          title: Text(gridComponent.component.name),
                          children: [
                            gridComponent.component is Wire
                                ? const SizedBox()
                                : gridComponent.component is Resistor
                                    ? const Row(
                                        children: [
                                          Text('R = '),
                                          Expanded(child: TextField()),
                                        ],
                                      )
                                    : const SizedBox(),
                          ],
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
