import 'dart:developer';

import 'package:circuit_solver/core/models/passive_components/capacitor.dart';
import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/core/models/passive_components/inductor.dart';
import 'package:circuit_solver/core/models/passive_components/resistor.dart';
import 'package:circuit_solver/core/models/sources/ac_voltage_source.dart';
import 'package:circuit_solver/core/models/sources/dc_voltage_source.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent;

class HomeNotifier extends ChangeNotifier {
  final FocusNode homeFocusNode = FocusNode();
  ToolboxComponent? selectedToolboxComponent;

  final List<GridComponent> _gridComponents = [];

  List<GridComponent> get gridComponents => [..._gridComponents];

  List<GridComponent> get selectedGridComponents =>
      _gridComponents.where((e) => e.isSelected).toList(
          // growable: false,
          );

  List<(Coordinate, int)> get allNodes => _gridComponents.fold(
        [],
        (prevValue, gridComponent) {
          final coordinates = [
            gridComponent.startCoordinate,
            gridComponent.endCoordinate,
          ];

          for (var coordinate in coordinates) {
            int index = prevValue.indexWhere((e) => e.$1 == coordinate);

            index == -1
                ? prevValue.add((coordinate, 1))
                : prevValue[index] = (
                    prevValue[index].$1,
                    prevValue[index].$2 + 1,
                  );
          }
          return prevValue;
        },
      );

  void selectToolboxComponent(ToolboxComponent? toolboxComponent) {
    selectedToolboxComponent = toolboxComponent;
    notifyListeners();
  }

  void selectGridComponent({
    required GridComponent gridComponent,
    required bool isSelected,
  }) {
    gridComponent.isSelected = isSelected;
    notifyListeners();
  }

  void _moveSelectedGridComponents(int dx, int dy) {
    for (var gridComponent in selectedGridComponents) {
      gridComponent.startCoordinate = Coordinate(
        x: gridComponent.startCoordinate.x + dx,
        y: gridComponent.startCoordinate.y + dy,
      );
      gridComponent.endCoordinate = Coordinate(
        x: gridComponent.endCoordinate.x + dx,
        y: gridComponent.endCoordinate.y + dy,
      );
    }
    notifyListeners();
  }

  void onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey.keyLabel) {
        case ' ':
          selectToolboxComponent(null);
        case 'W':
          selectToolboxComponent(ToolboxComponent.wire);
        case 'R':
          selectToolboxComponent(ToolboxComponent.resistor);
        case 'C':
          selectToolboxComponent(ToolboxComponent.capacitor);
        case 'L':
          selectToolboxComponent(ToolboxComponent.inductor);
        case 'Arrow Left':
          _moveSelectedGridComponents(-1, 0);
        case 'Arrow Right':
          _moveSelectedGridComponents(1, 0);
        case 'Arrow Up':
          _moveSelectedGridComponents(0, -1);
        case 'Arrow Down':
          _moveSelectedGridComponents(0, 1);
      }
    }
  }

  void _unselectAllGridComponents() {
    for (var gridComponent in _gridComponents) {
      gridComponent.isSelected = false;
    }
    notifyListeners();
  }

  void onPointerDown(PointerDownEvent event) {
    _unselectAllGridComponents();

    if (selectedToolboxComponent == null) {
      return;
    }

    final Coordinate startCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );
    final Coordinate endCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );

    Component component;

    switch (selectedToolboxComponent!) {
      case ToolboxComponent.wire:
        component = Wire();
      case ToolboxComponent.resistor:
        component = Resistor(resistance: 1000);
      case ToolboxComponent.capacitor:
        component = Capacitor(capacitance: 1 / 100000);
      case ToolboxComponent.inductor:
        component = Inductor(inductance: 1);
      case ToolboxComponent.acVoltageSource:
        component = ACVoltageSource(maxVoltage: 5);
      case ToolboxComponent.dcVoltageSource:
        component = DCVoltageSource(voltage: 5);
    }

    final gridComponent = GridComponent(
      component: component,
      startCoordinate: startCoordinate,
      endCoordinate: endCoordinate,
      isSelected: true,
    );
    _gridComponents.add(gridComponent);
    notifyListeners();
  }

  void onPointerMove(PointerMoveEvent event) {
    if (selectedGridComponents.length == 1) {
      selectedGridComponents.first.endCoordinate = Coordinate.fromOffset(
        event.localPosition,
      );
      notifyListeners();
    }
  }

  void onPointerUp(PointerUpEvent event) {
    if (selectedGridComponents.length != 1) return;
    if (selectedGridComponents.first.startCoordinate ==
        selectedGridComponents.first.endCoordinate) {
      _gridComponents.remove(selectedGridComponents.first);
    }
    _unselectAllGridComponents();
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
  acVoltageSource,
  dcVoltageSource,
}
