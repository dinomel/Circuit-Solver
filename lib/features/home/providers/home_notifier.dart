import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show KeyDownEvent;

class HomeNotifier extends ChangeNotifier {
  final FocusNode homeFocusNode = FocusNode();

  ToolboxComponent? selectedComponent;

  void selectComponent(ToolboxComponent? toolboxComponent) {
    selectedComponent = toolboxComponent;
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
