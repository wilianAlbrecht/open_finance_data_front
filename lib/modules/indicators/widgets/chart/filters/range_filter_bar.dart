import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/dados/price_range.dart';

class RangeFilterBar extends StatelessWidget {
  final PriceRange selected;
  final ValueChanged<PriceRange> onSelected;

  const RangeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final chip = pkg.filters; 

    return SizedBox(
      height: 42,
      child: Wrap(
        spacing: 8,
        children: PriceRange.values.map((range) {
          final isSelected = range == selected;

          return GestureDetector(
            onTap: () => onSelected(range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? chip.selectedBg.withAlpha(60)  : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? chip.selectedBorder : chip.borderColor,
                  width: isSelected ? 1.4 : 1,
                ),
              ),
              child: Text(
                range.label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? chip.selectedTextColor: chip.textColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
