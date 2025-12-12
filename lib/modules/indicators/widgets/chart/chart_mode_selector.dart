import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

class ChartModeSelector extends StatelessWidget {
  final ChartMode selected;
  final ValueChanged<ChartMode> onChanged;

  const ChartModeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SegmentButton(
          label: "Preço",
          active: selected == ChartMode.price,
          onTap: () => onChanged(ChartMode.price),
        ),
        const SizedBox(width: 8),
        _SegmentButton(
          label: "Volume",
          active: selected == ChartMode.volume,
          onTap: () => onChanged(ChartMode.volume),
        ),
      ],
    );
  }
}

enum ChartMode { price, volume }

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final filter = pkg.filters; // <- use 'filters' como definido no package
    final text = pkg.text;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: filter.padding,
        decoration: BoxDecoration(
          color: active ? filter.selectedBackground.withAlpha(60) : filter.background,
          borderRadius: BorderRadius.circular(filter.radius),
          border: Border.all(
            color: active ? filter.selectedBackground : filter.borderColor,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: text.button.copyWith(
            color: active ? filter.selectedTextColor : filter.textColor,
          ),
        ),
      ),
    );
  }
}
