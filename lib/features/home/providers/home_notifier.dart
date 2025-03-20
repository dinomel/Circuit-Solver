import 'dart:developer';

import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent;
import 'package:uuid/uuid.dart';

class HomeNotifier extends ChangeNotifier {
  final FocusNode homeFocusNode = FocusNode();
  ToolboxComponent? selectedToolboxComponent;
  GridComponent? selectedGridComponent;

  final List<GridComponent> _gridComponents = [];

  List<GridComponent> get gridComponents => [..._gridComponents];

  void selectComponent(ToolboxComponent? toolboxComponent) {
    selectedToolboxComponent = toolboxComponent;
    notifyListeners();
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case ' ':
          selectComponent(null);
        case 'W':
          selectComponent(ToolboxComponent.wire);
        case 'R':
          selectComponent(ToolboxComponent.resistor);
        case 'C':
          selectComponent(ToolboxComponent.capacitor);
        case 'L':
          selectComponent(ToolboxComponent.inductor);
      }
    }
  }

  //

  @override
  void dispose() {
    homeFocusNode.dispose();
    super.dispose();
  }

  void onPointerDown(PointerDownEvent event) {
    if (selectedToolboxComponent == ToolboxComponent.wire) {
      final Coordinate startCoordinate = Coordinate.fromOffset(
        event.localPosition,
      );
      final Coordinate endCoordinate = Coordinate.fromOffset(
        event.localPosition,
      );

      final gridComponent = GridComponent(
        component: Wire(id: const Uuid().v4()),
        startCoordinate: startCoordinate,
        endCoordinate: endCoordinate,
      );
      _gridComponents.add(gridComponent);
      selectedGridComponent = gridComponent;

      notifyListeners();
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (selectedGridComponent != null) {
      selectedGridComponent!.endCoordinate = Coordinate.fromOffset(
        event.localPosition,
      );
      notifyListeners();
    }
  }

  void onPointerUp(PointerUpEvent event) {
    selectedGridComponent = null;
    notifyListeners();
  }
}

enum ToolboxComponent {
  wire,
  resistor,
  capacitor,
  inductor,
}
