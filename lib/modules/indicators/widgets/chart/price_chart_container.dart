import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/themes/extensions/app_card_theme.dart';
import '../../../../core/theme/themes/extensions/app_chart_theme.dart';
import '../../../../core/theme/app_text_styles.dart';

class PriceChartContainer extends StatefulWidget {
  final LineChartData chart;
  final List<LineChartBarData> series;
  final List<int> timestamp;

  const PriceChartContainer({
    super.key,
    required this.chart,
    required this.series,
    required this.timestamp,
  });

  @override
  State<PriceChartContainer> createState() => _PriceChartContainerState();
}

class _PriceChartContainerState extends State<PriceChartContainer> {
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
        borderRadius: cardTheme.radius == 16
            ? AppLayout.radiusMd
            : BorderRadius.circular(cardTheme.radius),
      ),
      child: LineChart(
        widget.chart.copyWith(
          lineBarsData: widget.series,

          // ================================
          //   TOUCH / HOVER DO MOUSE
          // ================================
          lineTouchData: LineTouchData(
            enabled: true,
            handleBuiltInTouches: true,

            touchCallback: (event, response) {
              if (!mounted) return;

              if (response == null ||
                  response.lineBarSpots == null ||
                  response.lineBarSpots!.isEmpty) {
                setState(() => hoveredIndex = null);
                return;
              }

              setState(() {
                hoveredIndex = response.lineBarSpots!.first.x.toInt();
              });
            },

            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) =>
                  Colors.black.withOpacity(0.75),

              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    spot.y.toStringAsFixed(2),
                    AppTextStyles.body.copyWith(
                      color: spot.bar.color,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),

          // =====================================================
          //   EXIBE DATA APENAS NAS DIVISÕES + QUANDO HOVER
          // =====================================================
          titlesData: widget.chart.titlesData.copyWith(
            bottomTitles: AxisTitles(
              sideTitles: widget.chart.titlesData.bottomTitles.sideTitles!.copyWith(
                interval: 1, // ← deixa todas as posições disponíveis
                getTitlesWidget: (value, meta) {
                  return _buildXAxisLabel(
                    context,
                    value,
                    widget.timestamp,
                    hoveredIndex,
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

  // =====================================================
  //    FUNÇÃO QUE DECIDE QUANDO MOSTRAR A DATA
  // =====================================================

  Widget _buildXAxisLabel(
    BuildContext context,
    double value,
    List<int> timestamp,
    int? hoveredIndex,
  ) {
    final index = value.toInt();

    if (index < 0 || index >= timestamp.length) {
      return const SizedBox.shrink();
    }

    final isDivision = index % 6 == 0; // divisões principais
    final isHovered = hoveredIndex == index;

    // Só exibe quando for divisão principal ou ponto sob o mouse
    if (!isDivision && !isHovered) {
      return const SizedBox.shrink();
    }

    final dt = DateTime.fromMillisecondsSinceEpoch(
      timestamp[index] * 1000,
    );

    final label =
        "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year.toString().substring(2)}";

    return Text(
      label,
      style: AppTextStyles.body.copyWith(
        fontSize: 10,
        color: Theme.of(context).extension<AppChartTheme>()!.axisLabelColor,
      ),
    );
  }
}
