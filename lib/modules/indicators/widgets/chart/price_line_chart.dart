import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/themes/extensions/app_chart_theme.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';

class PriceLineChart extends StatelessWidget {
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;

  final bool showOpen;
  final bool showHigh;
  final bool showLow;
  final bool showClose;

  final List<int> timestamp;

  const PriceLineChart({
    super.key,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
    this.showOpen = false,
    this.showHigh = false,
    this.showLow = false,
    this.showClose = true,
  });

  List<FlSpot> _spots(List<double> data) =>
      List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i]));

  String _formatDate(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    return DateFormat('dd/MM/yy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final textSecondary = Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7);

    // Valores dinâmicos (escala Y)
    final allValues = [
      ...close,
      if (showOpen) ...open,
      if (showHigh) ...high,
      if (showLow) ...low,
    ];

    final minY = allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.reduce((a, b) => a > b ? a : b);
    final diff = maxY - minY;
    final step = diff / 4;

    // ===== SERIES DO GRÁFICO =====
    final series = <LineChartBarData>[];

    if (showClose) {
      series.add(
        LineChartBarData(
          spots: _spots(close),
          color: chartTheme.closeColor,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showOpen) {
      series.add(
        LineChartBarData(
          spots: _spots(open),
          color: chartTheme.openColor,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showHigh) {
      series.add(
        LineChartBarData(
          spots: _spots(high),
          color: chartTheme.highColor,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showLow) {
      series.add(
        LineChartBarData(
          spots: _spots(low),
          color: chartTheme.lowColor,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    // ===== GRID X =====
    final stepX = (timestamp.length / 4).floor();
    final tickPositions = List.generate(5, (i) => (i * stepX).toDouble());
    const tolerance = 0.3;

    return Container(
      height: 270,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: AppLayout.paddingSm,
      decoration: BoxDecoration(
        color: cardTheme.background,
        borderRadius: cardTheme.radius == 16
            ? AppLayout.radiusMd
            : BorderRadius.circular(cardTheme.radius),
      ),
      child: LineChart(
        LineChartData(
          minY: minY - diff * 0.1,
          maxY: maxY + diff * 0.1,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: chartTheme.gridColor, strokeWidth: 1),
            getDrawingVerticalLine: (value) {
              final isTick = tickPositions.any((tick) => (value - tick).abs() < tolerance);

              return FlLine(
                color: isTick ? chartTheme.gridColor : Colors.transparent,
                strokeWidth: 1,
              );
            },
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: step,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(2),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 10,
                    color: textSecondary,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (timestamp.length / 4).floorToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= timestamp.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    _formatDate(timestamp[index]),
                    style: AppTextStyles.body.copyWith(
                      fontSize: 10,
                      color: textSecondary,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          borderData: FlBorderData(show: false),
          lineBarsData: series,
        ),
      ),
    );
  }
}
