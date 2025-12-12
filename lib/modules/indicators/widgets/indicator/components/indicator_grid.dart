import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';

class IndicatorGrid extends StatelessWidget {
  final List<Widget> children;

  const IndicatorGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // ============================
    //   BREAKPOINTS DO GRID
    // ============================
    final crossAxisCount =
        width >= AppLayout.desktopBreakpoint ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppLayout.indicatorGridSpacing,
        mainAxisSpacing: AppLayout.indicatorGridSpacing,
        childAspectRatio: AppLayout.indicatorAspectRatio,
      ),

      itemBuilder: (_, i) => children[i],
    );
  }
}
