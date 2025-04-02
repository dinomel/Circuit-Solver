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
import 'package:flutter/services.dart'
    show KeyDownEvent, KeyUpEvent, PointerHoverEvent;

class HomeNotifier extends ChangeNotifier {
  static const double componentHoverRadius = 12.0;

  final FocusNode homeFocusNode = FocusNode();
  ToolboxComponent? selectedToolboxComponent;
  final List<GridComponent> _gridComponents = [];
  Rect? selectionRect;
  Offset? _selectionRectStartPosition;
  Offset? _selectionRectEndPosition;
  GridComponent? hoveredGridComponent;
  Coordinate? hoveredCoordinate;

  bool _isHoldingShift = false;

  final List<(String, Coordinate, Coordinate)> _initialMoveCoordinates = [];

  List<GridComponent> get gridComponents => [..._gridComponents];

  List<GridComponent> get selectedGridComponents =>
      _gridComponents.where((e) => e.isSelected).toList();

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
    if (event is KeyUpEvent) {
      _isHoldingShift = false;
      return;
    }
    if (event is! KeyDownEvent) return;
    switch (event.logicalKey.keyLabel) {
      case 'Shift Left':
        _isHoldingShift = true;
        break;
      case ' ':
        selectToolboxComponent(null);
        break;
      case 'W':
        selectToolboxComponent(ToolboxComponent.wire);
        break;
      case 'R':
        selectToolboxComponent(ToolboxComponent.resistor);
        break;
      case 'C':
        selectToolboxComponent(ToolboxComponent.capacitor);
        break;
      case 'L':
        selectToolboxComponent(ToolboxComponent.inductor);
        break;
      case 'Arrow Left':
        _moveSelectedGridComponents(-1, 0);
        break;
      case 'Arrow Right':
        _moveSelectedGridComponents(1, 0);
        break;
      case 'Arrow Up':
        _moveSelectedGridComponents(0, -1);
        break;
      case 'Arrow Down':
        _moveSelectedGridComponents(0, 1);
        break;
      case 'Backspace':
        _deleteSelectedGridComponents();
        break;
    }
  }

  void _unselectAllGridComponents() {
    for (var gridComponent in _gridComponents) {
      gridComponent.isSelected = false;
    }
    notifyListeners();
  }

  bool _isMovingNode = false;
  Offset? _pointerDownPosition;

  void onPointerDown(PointerDownEvent event) {
    if (selectedToolboxComponent == null) {
      if (hoveredCoordinate != null) {
        _unselectAllGridComponents();
        _isMovingNode = true;
        return;
      }
      if (hoveredGridComponent != null) {
        if (!_isHoldingShift && !hoveredGridComponent!.isSelected) {
          _unselectAllGridComponents();
        }

        selectGridComponent(
          gridComponent: hoveredGridComponent!,
          isSelected:
              _isHoldingShift ? !hoveredGridComponent!.isSelected : true,
        );
        _pointerDownPosition = event.localPosition;
        for (var gridComponent in _gridComponents) {
          if (gridComponent.isSelected) {
            _initialMoveCoordinates.add(
              (
                gridComponent.component.id,
                gridComponent.startCoordinate,
                gridComponent.endCoordinate,
              ),
            );
          }
        }
        return;
      }
      _unselectAllGridComponents();

      _selectionRectStartPosition = event.localPosition;
      _selectionRectEndPosition = event.localPosition;
      selectionRect = Rect.fromPoints(
        _selectionRectStartPosition!,
        _selectionRectEndPosition!,
      );

      notifyListeners();
      return;
    }

    _unselectAllGridComponents();
    final Coordinate startCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );
    final Coordinate endCoordinate = Coordinate.fromOffset(
      event.localPosition,
    );

    Component component = switch (selectedToolboxComponent!) {
      ToolboxComponent.wire => Wire(),
      ToolboxComponent.resistor => Resistor(resistance: 1000),
      ToolboxComponent.capacitor => Capacitor(capacitance: 1 / 100000),
      ToolboxComponent.inductor => Inductor(inductance: 1),
      ToolboxComponent.acVoltageSource => ACVoltageSource(maxVoltage: 5),
      ToolboxComponent.dcVoltageSource => DCVoltageSource(voltage: 5)
    };

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
        if (hoveredCoordinate == hoveredGridComponent?.startCoordinate) {
          hoveredGridComponent?.startCoordinate = Coordinate.fromOffset(
            event.localPosition,
          );
          hoveredCoordinate = hoveredGridComponent?.startCoordinate;
        } else {
          hoveredGridComponent?.endCoordinate = Coordinate.fromOffset(
            event.localPosition,
          );
          hoveredCoordinate = hoveredGridComponent?.endCoordinate;
        }
        notifyListeners();
        return;
      }

      if (hoveredGridComponent != null) {
        final dOffset = event.localPosition - _pointerDownPosition!;

        for (var gridComponent in _gridComponents) {
          if (gridComponent.isSelected) {
            final initialGridComponent = _initialMoveCoordinates
                .firstWhere((e) => e.$1 == gridComponent.component.id);
            final initialStartCoordinate = initialGridComponent.$2;
            final initialEndCoordinate = initialGridComponent.$3;

            final newStartCoordinate = Coordinate.fromOffset(
              initialStartCoordinate.toOffset() + dOffset,
            );

            if (gridComponent.startCoordinate != newStartCoordinate) {
              gridComponent.startCoordinate = newStartCoordinate;
              gridComponent.endCoordinate = Coordinate.fromOffset(
                initialEndCoordinate.toOffset() + dOffset,
              );
            }
          }
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
      hoveredGridComponent = null;
      hoveredCoordinate = null;
      _isMovingNode = false;
      _pointerDownPosition = null;
      _initialMoveCoordinates.clear();
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

    hoveredGridComponent = _gridComponents.firstWhereOrNull(
      (gridComponent) =>
          gridComponent.distanceToOffsetSquared(pos) <
          componentHoverRadius * componentHoverRadius,
    );

    final coordinate = Coordinate.fromOffset(pos);
    final offset = coordinate.toOffset();
    if ((offset - pos).distanceSquared > componentHoverRadius) {
      hoveredCoordinate = null;
      notifyListeners();
      return;
    }
    final gridComponentWithCoordinate = _gridComponents.firstWhereOrNull(
      (gridComponent) =>
          gridComponent.startCoordinate == coordinate ||
          gridComponent.endCoordinate == coordinate,
    );
    if (gridComponentWithCoordinate == null) return;
    hoveredCoordinate = coordinate;
    hoveredGridComponent = gridComponentWithCoordinate;
    notifyListeners();
  }

  @override
  void dispose() {
    homeFocusNode.dispose();
    super.dispose();
  }

  void _deleteSelectedGridComponents() {
    _gridComponents.removeWhere((e) => e.isSelected);
    notifyListeners();
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
