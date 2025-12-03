import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final controller = context.read<ThemeController>();

    return IconButton(
      tooltip: 'Alterar tema',
      onPressed: controller.toggleTheme,
      icon: Icon(
        brightness == Brightness.dark ? Icons.wb_sunny : Icons.dark_mode,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
