import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_item.dart';
import 'models/indicator_item_data.dart';

class IndicatorGrid extends StatelessWidget {
  final List<IndicatorItemData> items;
  final int columns;

  const IndicatorGrid({
    super.key,
    required this.items,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppLayout.indicatorGridSpacing,
      crossAxisSpacing: AppLayout.indicatorGridSpacing,
      childAspectRatio: AppLayout.indicatorAspectRatio,
      children: items
          .map((item) => IndicatorItem(data: item))
          .toList(),
    );
  }
}
