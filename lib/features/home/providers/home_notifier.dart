import 'package:circuit_solver/core/models/passive_components/capacitor.dart';
import 'package:circuit_solver/core/models/component.dart';
import 'package:circuit_solver/core/models/passive_components/inductor.dart';
import 'package:circuit_solver/core/models/passive_components/resistor.dart';
import 'package:circuit_solver/core/models/sources/ac_voltage_source.dart';
import 'package:circuit_solver/core/models/sources/dc_voltage_source.dart';
import 'package:circuit_solver/core/models/wire.dart';
import 'package:circuit_solver/features/home/models/coordinate.dart';
import 'package:circuit_solver/features/home/models/grid_component.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent, PointerHoverEvent;

class HomeNotifier extends ChangeNotifier {
  final FocusNode homeFocusNode = FocusNode();
  ToolboxComponent? selectedToolboxComponent;
  final List<GridComponent> _gridComponents = [];
  Rect? selectionRect;
  Offset? _selectionRectStartPosition;
  Offset? _selectionRectEndPosition;
  GridComponent? _hoveredGridComponent;
  Coordinate? hoveredCoordinate;

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

  bool _isMovingNode = false;

  void onPointerDown(PointerDownEvent event) {
    _unselectAllGridComponents();

    if (selectedToolboxComponent == null) {
      if (hoveredCoordinate != null) {
        _isMovingNode = true;
        return;
      }
      //TODO: if a component is behind it should be selected and no rect is drawn,
      //TODO: instead that component should be moved

      _selectionRectStartPosition = event.localPosition;
      _selectionRectEndPosition = event.localPosition;
      selectionRect = Rect.fromPoints(
        _selectionRectStartPosition!,
        _selectionRectEndPosition!,
      );

      notifyListeners();
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
    if (selectedToolboxComponent == null) {
      if (hoveredCoordinate != null) {
        if (hoveredCoordinate == _hoveredGridComponent?.startCoordinate) {
          _hoveredGridComponent?.startCoordinate = Coordinate.fromOffset(
            event.localPosition,
          );
          hoveredCoordinate = _hoveredGridComponent?.startCoordinate;
        } else {
          _hoveredGridComponent?.endCoordinate = Coordinate.fromOffset(
            event.localPosition,
          );
          hoveredCoordinate = _hoveredGridComponent?.endCoordinate;
        }
        notifyListeners();
        return;
      }

      if (_selectionRectStartPosition == null) return;
      _selectionRectEndPosition = event.localPosition;
      selectionRect = Rect.fromPoints(
        _selectionRectStartPosition!,
        _selectionRectEndPosition!,
      );
      // select components
      for (var gridComponent in _gridComponents) {
        if (selectionRect!.contains(gridComponent.startCoordinate.toOffset()) ||
            selectionRect!.contains(gridComponent.endCoordinate.toOffset())) {
          gridComponent.isSelected = true;
        } else {
          gridComponent.isSelected = false;
        }
      }
      notifyListeners();

      return;
    }
    if (selectedGridComponents.length != 1) return;

    selectedGridComponents.first.endCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );
    notifyListeners();
  }

  void onPointerUp(PointerUpEvent event) {
    if (selectedToolboxComponent == null) {
      selectionRect = null;
      _selectionRectStartPosition = null;
      _selectionRectEndPosition = null;
      _hoveredGridComponent = null;
      hoveredCoordinate = null;
      _isMovingNode = false;
      notifyListeners();
      return;
    }
    if (selectedGridComponents.length != 1) return;
    if (selectedGridComponents.first.startCoordinate ==
        selectedGridComponents.first.endCoordinate) {
      _gridComponents.remove(selectedGridComponents.first);
    }
    _unselectAllGridComponents();
    notifyListeners();
  }

  void onPointerHover(PointerHoverEvent event) {
    if (selectedToolboxComponent != null || _isMovingNode) return;
    final pos = event.localPosition;
    final coordinate = Coordinate.fromOffset(pos);
    final offset = coordinate.toOffset();

    if ((offset - pos).distanceSquared > 16) {
      _hoveredGridComponent = null;
      hoveredCoordinate = null;
      notifyListeners();
      return;
    }

    _hoveredGridComponent = _gridComponents.firstWhereOrNull(
      (gridComponent) =>
          gridComponent.startCoordinate == coordinate ||
          gridComponent.endCoordinate == coordinate,
    );
    if (_hoveredGridComponent == null) return;
    hoveredCoordinate = coordinate;
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
