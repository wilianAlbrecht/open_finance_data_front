import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/themes/extensions/app_chip_theme.dart';

import '../../indicators_controller.dart';

class PriceFilterBar extends StatelessWidget {
  const PriceFilterBar({super.key});

  Widget _chip({
    required BuildContext context,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final chipTheme = Theme.of(context).extension<AppChipTheme>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: active ? Theme.of(context).colorScheme.primary : chipTheme.labelColor,
          ),
        ),
        selected: active,
        selectedColor: chipTheme.selectedBg,
        disabledColor: chipTheme.selectedBg.withOpacity(0.3),
        pressElevation: 0,
        side: BorderSide(
          color: active ? Theme.of(context).colorScheme.primary : chipTheme.borderColor,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IndicatorsController>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        children: [
          _chip(
            context: context,
            label: "Open",
            active: controller.showOpen,
            onTap: controller.toggleOpen,
          ),
          _chip(
            context: context,
            label: "High",
            active: controller.showHigh,
            onTap: controller.toggleHigh,
          ),
          _chip(
            context: context,
            label: "Low",
            active: controller.showLow,
            onTap: controller.toggleLow,
          ),
          _chip(
            context: context,
            label: "Close",
            active: controller.showClose,
            onTap: controller.toggleClose,
          ),
        ],
      ),
    );
  }
}
