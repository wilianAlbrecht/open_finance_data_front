import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_layout.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_card_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_chart_theme.dart';

import 'volume_chart_builder.dart';

class VolumeChartLayout extends StatelessWidget {
  final List<double> volume;
  final List<int> timestamp;

  const VolumeChartLayout({
    super.key,
    required this.volume,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

    final builder = VolumeChartBuilder(volume: volume, timestamp: timestamp);

    const Color volumeColor = Color(0x661E88E5); // azul suave da paleta
    final bars = builder.buildBars(volumeColor);
    final maxVolume = builder.getMaxVolume();

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
        borderRadius: AppLayout.radiusMd,
      ),
      child: BarChart(
        BarChartData(
          barGroups: bars,
          minY: 0,
          maxY: maxVolume,

          // GRID HORIZONTAL LEVE
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxVolume / 6, // <--- CORRETO
            getDrawingHorizontalLine: (_) =>
                FlLine(strokeWidth: 0.4, color: chartTheme.gridColor),
          ),

          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            // EIXO Y (VOLUME)
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) {
                  return Text(
                    builder.formatVolume(value),
                    style: TextStyle(
                      fontSize: 10,
                      color: chartTheme.axisLabelColor,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

            // EIXO X (DATAS)
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 1,
                getTitlesWidget: (value, _) {
                  final index = value.round();

                  if (index < 0 || index >= timestamp.length) {
                    return const SizedBox.shrink();
                  }

                  int stepX = (timestamp.length / 6).floor();
                  if (stepX <= 0) stepX = 1;

                  final isDivision = index % stepX == 0;

                  if (!isDivision) return const SizedBox.shrink();

                  final dt = DateTime.fromMillisecondsSinceEpoch(
                    timestamp[index] * 1000,
                  );
                  return Text(
                    "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontSize: 10,
                      color: chartTheme.axisLabelColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
