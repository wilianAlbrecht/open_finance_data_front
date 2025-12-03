import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';

class PriceChartContainer extends StatelessWidget {
  final LineChartData chart;
  final List<LineChartBarData> series;

  const PriceChartContainer({
    super.key,
    required this.chart,
    required this.series,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;

    return Container(
      height: 270,
      margin: AppLayout.marginMd,
      padding: EdgeInsets.fromLTRB(
        AppLayout.paddingSm.left,
        AppLayout.paddingSm.top,
        AppLayout.paddingSm.right + AppLayout.axisRightReserved,
        AppLayout.paddingSm.bottom,
      ),
      decoration: BoxDecoration(
        color: cardTheme.background,
        borderRadius: cardTheme.radius == 16
            ? AppLayout.radiusMd
            : BorderRadius.circular(cardTheme.radius),
      ),
      child: LineChart(
        chart.copyWith(
          lineBarsData: series,
        ),
      ),
    );
  }
}
