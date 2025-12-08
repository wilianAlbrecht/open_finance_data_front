import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_chart_theme.dart';

class TooltipSeries {
  final String label;
  final Color color;
  final List<double> values;

  TooltipSeries({
    required this.label,
    required this.color,
    required this.values,
  });
}

class CanvasLineChartData {
  final List<Offset> openPoints;
  final List<Offset> highPoints;
  final List<Offset> lowPoints;
  final List<Offset> closePoints;

  final List<Offset> points; // referência principal usada pelo hover

  final double chartLeft;
  final double chartRight;
  final double chartTop;
  final double chartBottom;

  final List<String> fullXLabels;

  final double minValue;
  final double maxValue;

  final List<double> gridY;
  final List<double> gridValues;

  final List<double> labelX;
  final List<int> labelIndexes;

  final List<String> yLabels;
  final List<String> xLabels;

  final List<TooltipSeries> tooltipSeries;

  CanvasLineChartData({
    required this.openPoints,
    required this.highPoints,
    required this.lowPoints,
    required this.closePoints,
    required this.points,
    required this.chartLeft,
    required this.chartRight,
    required this.chartTop,
    required this.chartBottom,
    required this.minValue,
    required this.maxValue,
    required this.gridY,
    required this.gridValues,
    required this.labelX,
    required this.labelIndexes,
    required this.yLabels,
    required this.xLabels,
    required this.fullXLabels,
    required this.tooltipSeries,
  });
}

class CanvasLineChartBuilder {
  final BuildContext context;
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;

  final bool showOpen;
  final bool showHigh;
  final bool showLow;
  final bool showClose;

  final List<int> timestamp;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double chartWidth;
  final double chartHeight;


  CanvasLineChartBuilder({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.showOpen,
    required this.showHigh,
    required this.showLow,
    required this.showClose,
    required this.timestamp,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.chartWidth,
    required this.chartHeight,
    required this.context,
  });

  CanvasLineChartData build() {
  final chartTheme = Theme.of(context).extension<AppChartTheme>()!;

    // -------------------------------------------------
    // 1. CALCULAR RANGE REAL
    // -------------------------------------------------
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    void include(List<double> s, bool active) {
      if (!active) return;
      for (final v in s) {
        if (v < minValue) minValue = v;
        if (v > maxValue) maxValue = v;
      }
    }

    include(open, showOpen);
    include(high, showHigh);
    include(low, showLow);
    include(close, showClose);

    // fallback caso tudo esteja desativado
    if (minValue == double.infinity || maxValue == double.negativeInfinity) {
      minValue = close.reduce(min);
      maxValue = close.reduce(max);
    }

    // padding vertical
    final range0 = maxValue - minValue;
    final paddingFactor = 0.15;

    minValue -= range0 * paddingFactor;
    maxValue += range0 * paddingFactor;

    final range = maxValue - minValue;

    // -------------------------------------------------
    // 2. ÁREA ÚTIL
    // -------------------------------------------------
    final chartLeft = paddingLeft;
    final chartRight = chartWidth - paddingRight;
    final chartTop = paddingTop;
    final chartBottom = chartHeight - paddingBottom;

    final usableHeight = chartBottom - chartTop;
    final usableWidth = chartRight - chartLeft;

    double valueToY(double v) {
      final normalized = (v - minValue) / range;
      return chartBottom - normalized * usableHeight;
    }

    // -------------------------------------------------
    // 3. PONTOS DE TODAS AS SÉRIES
    // -------------------------------------------------
    final count = close.length;
    final dx = count > 1 ? usableWidth / (count - 1) : 0.0;

    List<Offset> buildPoints(List<double> series) {
      return List.generate(series.length, (i) {
        return Offset(
          chartLeft + i * dx,
          valueToY(series[i]),
        );
      });
    }

    final openPoints = showOpen ? buildPoints(open) : <Offset>[];
    final highPoints = showHigh ? buildPoints(high) : <Offset>[];
    final lowPoints = showLow ? buildPoints(low) : <Offset>[];
    final closePoints = showClose ? buildPoints(close) : <Offset>[];

    // série para hover base
    final List<Offset> basePoints =
        closePoints.isNotEmpty ? closePoints : buildPoints(close);

    // -------------------------------------------------
    // 4. GRID
    // -------------------------------------------------
    const gridLines = 5;
    final gridValues = <double>[];
    final gridY = <double>[];

    for (int i = 0; i <= gridLines; i++) {
      final gv = minValue + (range / gridLines) * i;
      gridValues.add(gv);
      gridY.add(valueToY(gv));
    }

    final yLabels = gridValues.map((v) => v.toStringAsFixed(2)).toList();

    // -------------------------------------------------
    // 5. LABELS DO EIXO X
    // -------------------------------------------------
    const labelCount = 6;
    final labelX = <double>[];
    final labelIndexes = <int>[];

    if (count > 0) {
      final step = max(1, (count / labelCount).floor());
      for (int i = 0; i < count; i += step) {
        labelIndexes.add(i);
        labelX.add(chartLeft + i * dx);
      }
    }

    final xLabels = labelIndexes.map((i) {
      final dt = DateTime.fromMillisecondsSinceEpoch(timestamp[i] * 1000);
      return "${dt.day}/${dt.month}/${dt.year}";
    }).toList();

    final fullXLabels = timestamp.map((ts) {
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      return "${dt.day}/${dt.month}/${dt.year}";
    }).toList();

    // -------------------------------------------------
    // 6. SÉRIES DO TOOLTIP (CORES DO TEMA)
    // -------------------------------------------------
    final tooltipSeries = <TooltipSeries>[];

    if (showOpen) {
      tooltipSeries.add(
        TooltipSeries(label: "Open", color: chartTheme.openColor, values: open),
      );
    }
    if (showHigh) {
      tooltipSeries.add(
        TooltipSeries(label: "High", color: chartTheme.highColor, values: high),
      );
    }
    if (showLow) {
      tooltipSeries.add(
        TooltipSeries(label: "Low", color: chartTheme.lowColor, values: low),
      );
    }
    if (showClose) {
      tooltipSeries.add(
        TooltipSeries(label: "Close", color: chartTheme.closeColor, values: close),
      );
    }

    return CanvasLineChartData(
      openPoints: openPoints,
      highPoints: highPoints,
      lowPoints: lowPoints,
      closePoints: closePoints,
      points: basePoints,
      chartLeft: chartLeft,
      chartRight: chartRight,
      chartTop: chartTop,
      chartBottom: chartBottom,
      minValue: minValue,
      maxValue: maxValue,
      gridY: gridY,
      gridValues: gridValues,
      labelX: labelX,
      labelIndexes: labelIndexes,
      yLabels: yLabels,
      xLabels: xLabels,
      fullXLabels: fullXLabels,
      tooltipSeries: tooltipSeries,
    );
  }
}
