import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../indicators_controller.dart';

class PriceFilterBar extends StatelessWidget {
  const PriceFilterBar({super.key});

  Widget _chip({
    required BuildContext context,
    required String label,
    required bool active,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: ChoiceChip(
        label: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: active ? color : theme.textTheme.bodyMedium!.color,
          ),
        ),
        selected: active,
        selectedColor: color.withOpacity(0.18),
        backgroundColor: theme.colorScheme.surface.withOpacity(0.6),
        side: BorderSide(
          color: active ? color : theme.dividerColor,
          width: 1.2,
        ),
        pressElevation: 0,
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
            color: AppColors.filterOpen,
            onTap: controller.toggleOpen,
          ),
          _chip(
            context: context,
            label: "High",
            active: controller.showHigh,
            color: AppColors.filterHigh,
            onTap: controller.toggleHigh,
          ),
          _chip(
            context: context,
            label: "Low",
            active: controller.showLow,
            color: AppColors.filterLow,
            onTap: controller.toggleLow,
          ),
          _chip(
            context: context,
            label: "Close",
            active: controller.showClose,
            color: AppColors.filterClose,
            onTap: controller.toggleClose,
          ),
        ],
      ),
    );
  }
}
