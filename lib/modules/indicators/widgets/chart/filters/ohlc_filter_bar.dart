import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/themes/extensions/app_theme_package.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../controllers/price_chart_controller.dart';

class OhlcFilterBar extends StatelessWidget {
  const OhlcFilterBar({super.key});

  Widget _chip({
    required BuildContext context,
    required String label,
    required bool active,
    required Color color,
    required VoidCallback onTap,
  }) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final filterTheme = pkg.filters;
    final textTheme = pkg.text;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: filterTheme.padding,
          decoration: BoxDecoration(
            color: active
                ? color.withAlpha(60)
                : filterTheme.background,
            borderRadius: BorderRadius.circular(filterTheme.radius),
            border: Border.all(
              color: active ? color : filterTheme.borderColor,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: textTheme.body.copyWith(
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? color : filterTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<IndicatorsController>();
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final canvas = pkg.canvas;

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
            color: canvas.openColor,
            onTap: () => controller.toggleOpen(context),
          ),
          _chip(
            context: context,
            label: "High",
            active: controller.showHigh,
            color: canvas.highColor,
            onTap: () => controller.toggleHigh(context),
          ),
          _chip(
            context: context,
            label: "Low",
            active: controller.showLow,
            color: canvas.lowColor,
            onTap: () => controller.toggleLow(context),
          ),
          _chip(
            context: context,
            label: "Close",
            active: controller.showClose,
            color: canvas.closeColor,
            onTap: () => controller.toggleClose(context),
          ),
        ],
      ),
    );
  }
}
