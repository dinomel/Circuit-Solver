import 'package:circuit_solver/features/home/providers/home_notifier.dart';
import 'package:circuit_solver/features/home/views/background_canvas/background_canvas.dart';
import 'package:circuit_solver/features/home/views/toolbox/toolbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeNotifier(),
      builder: (context, _) {
        final homeNotifier = context.read<HomeNotifier>();
        return Scaffold(
          body: KeyboardListener(
            onKeyEvent: homeNotifier.onKeyEvent,
            focusNode: homeNotifier.homeFocusNode..requestFocus(),
            child: const Row(
              children: [
                Expanded(child: BackgroundCanvas()),
                Toolbox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
