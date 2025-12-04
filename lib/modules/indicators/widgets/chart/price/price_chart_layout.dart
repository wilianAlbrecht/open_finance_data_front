import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/app_text_styles.dart';

import '../../../../../core/theme/app_layout.dart';
import '../../../../../core/theme/themes/extensions/app_card_theme.dart';
import '../../../../../core/theme/themes/extensions/app_chart_theme.dart';

class PriceChartLayout extends StatefulWidget {
  final LineChartData chart;
  final List<LineChartBarData> series;
  final List<int> timestamp;

  const PriceChartLayout({
    super.key,
    required this.chart,
    required this.series,
    required this.timestamp,
  });

  @override
  State<PriceChartLayout> createState() => _PriceChartLayoutState();
}

class _PriceChartLayoutState extends State<PriceChartLayout> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).extension<AppCardTheme>()!;
    final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

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
      child: LineChart(
        widget.chart.copyWith(
          lineBarsData: widget.series,
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchCallback: (event, response) {
              if (!mounted) return;

              // Se não há spots → limpar hover
              if (response == null ||
                  response.lineBarSpots == null ||
                  response.lineBarSpots!.isEmpty) {
                if (mounted) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => hoveredIndex = null);
                  });
                }
                return;
              }

              // Atualizar hover de forma segura
              final index = response.lineBarSpots!.first.x.toInt();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => hoveredIndex = index);
              });
            },

            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black.withOpacity(0.75),
              getTooltipItems: (touchedSpots) {
                return touchedSpots
                    .map(
                      (spot) => LineTooltipItem(
                        spot.y.toStringAsFixed(2),
                        AppTextStyles.body.copyWith(
                          color: spot.bar.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    .toList();
              },
            ),
          ),

          // SOBREPOSIÇÃO VISUAL DO HOVER NO EIXO X
          titlesData: widget.chart.titlesData.copyWith(
            bottomTitles: AxisTitles(
              sideTitles: widget.chart.titlesData.bottomTitles.sideTitles.copyWith(
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  final step = (widget.timestamp.length / 6).floor();
                  final isDivision = step > 0 && index % step == 0;
                  final isHovered = hoveredIndex == index;

                  if (!isDivision && !isHovered) {
                    return const SizedBox.shrink();
                  }

                  if (index < 0 || index >= widget.timestamp.length) {
                    return const SizedBox.shrink();
                  }

                  final dt = DateTime.fromMillisecondsSinceEpoch(
                    widget.timestamp[index] * 1000,
                  );

                  final label =
                      "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year.toString().substring(2)}";

                  return Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 10,
                      color: chartTheme.axisLabelColor,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        duration: Duration.zero,
      ),
    );
  }
}
