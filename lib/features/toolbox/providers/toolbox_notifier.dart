import 'package:flutter/material.dart';

class ToolboxNotifier extends ChangeNotifier {
  ToolboxComponent? selectedComponent;

  void selectComponent(ToolboxComponent toolboxComponent) {
    selectedComponent = toolboxComponent;
    notifyListeners();
  }
}

enum ToolboxComponent {
  wire,
  resistor,
  capacitor,
  inductor,
}
