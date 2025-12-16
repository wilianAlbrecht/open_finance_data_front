import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';

class IndicatorGrid extends StatelessWidget {
  final List<Widget> children;
  final int columns;

  const IndicatorGrid({
    super.key,
    required this.children,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppLayout.indicatorGridSpacing,
        mainAxisSpacing: AppLayout.indicatorGridSpacing,
        childAspectRatio: AppLayout.indicatorAspectRatio,
      ),
      itemBuilder: (_, i) => children[i],
    );
  }
}
