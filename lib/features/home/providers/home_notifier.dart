import 'dart:developer';

import 'package:circuit_solver/core/models/capacitor.dart';
import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/core/models/inductor.dart';
import 'package:circuit_solver/core/models/resistor.dart';
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

  void onPointerDown(PointerDownEvent event) {
    if (selectedToolboxComponent == null) return;
    final Coordinate startCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );
    final Coordinate endCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );

    final String id = const Uuid().v4();
    Component component;

    switch (selectedToolboxComponent!) {
      case ToolboxComponent.wire:
        component = Wire(id: id);
      case ToolboxComponent.resistor:
        component = Resistor(id: id, resistance: 100);
      case ToolboxComponent.capacitor:
        component = Capacitor(id: id, capacitance: 0.1);
      case ToolboxComponent.inductor:
        component = Inductor(id: id, inductance: 1);
    }

    final gridComponent = GridComponent(
      component: component,
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
    );
    _gridComponents.add(gridComponent);
    selectedGridComponent = gridComponent;

    notifyListeners();
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
    if (selectedGridComponent == null) return;
    if (selectedGridComponent!.startCoordinate ==
        selectedGridComponent!.endCoordinate) {
      _gridComponents.remove(selectedGridComponent);
    }
    selectedGridComponent = null;
    notifyListeners();
  }

  @override
  void dispose() {
    homeFocusNode.dispose();
    super.dispose();
  }
}

enum ToolboxComponent {
  wire,
  resistor,
  capacitor,
  inductor,
}
