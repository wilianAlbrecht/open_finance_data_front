import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

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

  final List<Offset> points;

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
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;

  bool showOpen;
  bool showHigh;
  bool showLow;
  bool showClose;

  final List<int> timestamp;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double chartWidth;
  final double chartHeight;

  final BuildContext context;

  // 🔥 ZOOM + PAN STATE
  double zoom = 1.0;
  final double minZoom = 1.0;
  final double maxZoom = 8.0;

  int panOffset = 0;

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
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final chartColor = pkg.canvas;

    // -------------------------------------------------
    // 1. ZOOM + PAN WINDOW
    // -------------------------------------------------
    final totalCount = close.length;

    final visibleCount =
        (totalCount / zoom).clamp(10, totalCount).toInt();

    panOffset = panOffset.clamp(
      0,
      max(0, totalCount - visibleCount),
    );

    final endIndex = totalCount - panOffset;
    final startIndex = (endIndex - visibleCount).clamp(0, totalCount);

    List<double> slice(List<double> s) =>
        s.sublist(startIndex, endIndex);

    final openV = slice(open);
    final highV = slice(high);
    final lowV = slice(low);
    final closeV = slice(close);
    final timestampV = timestamp.sublist(startIndex, endIndex);

    // -------------------------------------------------
    // 2. RANGE Y (VISÍVEL)
    // -------------------------------------------------
    double minValue = double.infinity;
    double maxValue = double.negativeInfinity;

    void include(List<double> s, bool active) {
      if (!active) return;
      for (final v in s) {
        minValue = min(minValue, v);
        maxValue = max(maxValue, v);
      }
    }

    include(openV, showOpen);
    include(highV, showHigh);
    include(lowV, showLow);
    include(closeV, showClose);

    if (minValue == double.infinity) {
      minValue = closeV.reduce(min);
      maxValue = closeV.reduce(max);
    }

    final range0 = maxValue - minValue;
    const paddingFactor = 0.15;

    minValue -= range0 * paddingFactor;
    maxValue += range0 * paddingFactor;

    final range = maxValue - minValue;

    // -------------------------------------------------
    // 3. ÁREA ÚTIL
    // -------------------------------------------------
    final chartLeft = paddingLeft;
    final chartRight = chartWidth - paddingRight;
    final chartTop = paddingTop;
    final chartBottom = chartHeight - paddingBottom;

    final usableHeight = chartBottom - chartTop;
    final usableWidth = chartRight - chartLeft;

    double valueToY(double v) {
      final norm = (v - minValue) / range;
      return chartBottom - norm * usableHeight;
    }

    // -------------------------------------------------
    // 4. PONTOS
    // -------------------------------------------------
    final count = closeV.length;
    final dx = count > 1 ? usableWidth / (count - 1) : 0.0;

    List<Offset> buildPoints(List<double> series) {
      return List.generate(series.length, (i) {
        return Offset(
          chartLeft + i * dx,
          valueToY(series[i]),
        );
      });
    }

    final openPoints = showOpen ? buildPoints(openV) : <Offset>[];
    final highPoints = showHigh ? buildPoints(highV) : <Offset>[];
    final lowPoints = showLow ? buildPoints(lowV) : <Offset>[];
    final closePoints = showClose ? buildPoints(closeV) : <Offset>[];

    final basePoints =
        closePoints.isNotEmpty ? closePoints : buildPoints(closeV);

    // -------------------------------------------------
    // 5. GRID Y
    // -------------------------------------------------
    const gridLines = 5;
    final gridValues = <double>[];
    final gridY = <double>[];

    for (int i = 0; i <= gridLines; i++) {
      final v = minValue + range * (i / gridLines);
      gridValues.add(v);
      gridY.add(valueToY(v));
    }

    final yLabels =
        gridValues.map((v) => v.toStringAsFixed(2)).toList();

    // -------------------------------------------------
    // 6. LABELS X
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
      final dt =
          DateTime.fromMillisecondsSinceEpoch(timestampV[i] * 1000);
      return "${dt.day}/${dt.month}/${dt.year}";
    }).toList();

    final fullXLabels = timestampV.map((ts) {
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      return "${dt.day}/${dt.month}/${dt.year}";
    }).toList();

    // -------------------------------------------------
    // 7. TOOLTIP
    // -------------------------------------------------
    final tooltipSeries = <TooltipSeries>[];

    if (showOpen) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Open",
          color: chartColor.openColor,
          values: openV,
        ),
      );
    }
    if (showHigh) {
      tooltipSeries.add(
        TooltipSeries(
          label: "High",
          color: chartColor.highColor,
          values: highV,
        ),
      );
    }
    if (showLow) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Low",
          color: chartColor.lowColor,
          values: lowV,
        ),
      );
    }
    if (showClose) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Close",
          color: chartColor.closeColor,
          values: closeV,
        ),
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
