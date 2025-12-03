import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../indicators_controller.dart';

class PriceFilterBar extends StatelessWidget {
  const PriceFilterBar({super.key});

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: active,
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IndicatorsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        children: [
          _chip(
            label: "Open",
            active: controller.showOpen,
            onTap: controller.toggleOpen,
          ),
          _chip(
            label: "High",
            active: controller.showHigh,
            onTap: controller.toggleHigh,
          ),
          _chip(
            label: "Low",
            active: controller.showLow,
            onTap: controller.toggleLow,
          ),
          _chip(
            label: "Close",
            active: controller.showClose,
            onTap: controller.toggleClose,
          ),
        ],
      ),
    );
  }
}
