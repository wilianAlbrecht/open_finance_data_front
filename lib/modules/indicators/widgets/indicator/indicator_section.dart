import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'indicator_grid.dart';
import 'models/indicator_item_data.dart';
import 'package:open_finance_data_front/core/theme/app_spacing.dart';

class IndicatorSection extends StatelessWidget {
  final String title;
  final List<IndicatorItemData> items;
  final bool expanded;
  final VoidCallback onToggle;
  final int columns;

  const IndicatorSection({
    super.key,
    required this.title,
    required this.items,
    required this.expanded,
    required this.onToggle,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

    final int maxVisibleItems = columns * 2;
    final List<IndicatorItemData> visibleItems = expanded
        ? items
        : items.take(maxVisibleItems).toList();

    final bool hasOverflow = items.length > maxVisibleItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),

        Align(
          alignment: Alignment.center,
          child: IndicatorGrid(items: visibleItems, columns: columns),
        ),

        if (hasOverflow) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onToggle,
            child: Text(
              expanded ? "Ver menos" : "Ver mais",
              style: text.showMoreButton,
            ),
          ),
        ],
      ],
    );
  }
}
