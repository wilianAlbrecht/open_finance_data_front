import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'models/indicator_item_data.dart';

class IndicatorItem extends StatelessWidget {
  final IndicatorItemData data;

  const IndicatorItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final cardTheme = pkg.card;
    final text = pkg.text; // ✅ usa AppTextTheme

    return Container(
      padding: AppLayout.indicatorItemPadding,
      decoration: BoxDecoration(
        color: cardTheme.background,
        borderRadius: BorderRadius.circular(cardTheme.radius),
        border: Border.all(color: cardTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.label,
              style: text.bodySmall, 
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppLayout.indicatorGridSpacing),
          Text(
            data.value,
            style: data.highlight
                ? text
                      .number 
                : text.body, 
          ),
        ],
      ),
    );
  }
}
