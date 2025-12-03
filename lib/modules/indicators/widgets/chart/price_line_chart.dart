import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  List<FlSpot> _spots(List<double> data) {
    return List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i]),
    );
  }

  String _formatDate(int unix) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unix * 1000);
    return DateFormat('dd/MM/yy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    // ============================
    // Cálculo automático do eixo Y
    // ============================

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

    // ============================
    // Construção das séries
    // ============================

    List<LineChartBarData> series = [];

    if (showClose) {
      series.add(
        LineChartBarData(
          spots: _spots(close),
          color: Colors.blue,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showOpen) {
      series.add(
        LineChartBarData(
          spots: _spots(open),
          color: Colors.orange,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showHigh) {
      series.add(
        LineChartBarData(
          spots: _spots(high),
          color: Colors.green,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    if (showLow) {
      series.add(
        LineChartBarData(
          spots: _spots(low),
          color: Colors.red,
          isCurved: true,
          barWidth: 2,
        ),
      );
    }

    // ============================
    // LINHAS VERTICAIS NO GRID
    // ============================

    final stepX = (timestamp.length / 4).floor();
    final tickPositions = List.generate(5, (i) => (i * stepX).toDouble());
    const tolerance = 0.3;

    return Container(
      height: 270,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          minY: minY - diff * 0.1,
          maxY: maxY + diff * 0.1,

          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: Colors.grey.shade300, strokeWidth: 1),
            getDrawingVerticalLine: (value) {
              bool isTick = tickPositions.any((tick) {
                return (value - tick).abs() < tolerance;
              });

              return FlLine(
                color: isTick ? Colors.grey.shade300 : Colors.transparent,
                strokeWidth: 1,
              );
            },
          ),

          // ============================
          // EIXO Y - PREÇO
          // ============================
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: step,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            // ============================
            // EIXO X - DATAS (fixas)
            // ============================
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (timestamp.length / 4).floorToDouble(),
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();

                  if (index < 0 || index >= timestamp.length) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    _formatDate(timestamp[index]),
                    style: const TextStyle(fontSize: 10),
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
