import 'dart:math';
import 'package:flutter/material.dart';

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

  final List<Offset> points; // compatível com código antigo

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

  final Color openColor;
  final Color highColor;
  final Color lowColor;
  final Color closeColor;

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
    required this.openColor,
    required this.highColor,
    required this.lowColor,
    required this.closeColor,
  });

  CanvasLineChartData build() {
    // -------------------------------------------------
    // 1. CALCULAR RANGE
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

    // Se nenhuma série estiver ativa, usar valores padrão para manter o grid visível
    if (minValue == double.infinity || maxValue == double.negativeInfinity) {
      // Usar valores padrão baseados em todas as séries para calcular o range
      double fallbackMin = double.infinity;
      double fallbackMax = double.negativeInfinity;
      
      for (final v in [...open, ...high, ...low, ...close]) {
        if (v < fallbackMin) fallbackMin = v;
        if (v > fallbackMax) fallbackMax = v;
      }
      
      if (fallbackMin != double.infinity && fallbackMax != double.negativeInfinity) {
        minValue = fallbackMin;
        maxValue = fallbackMax;
      } else {
        // Fallback absoluto se não houver dados
        minValue = 0;
        maxValue = 100;
      }
    }

    // padding vertical extra
    final originalRange = maxValue - minValue;
    final paddingFactor = 0.15;

    minValue -= originalRange * paddingFactor;
    maxValue += originalRange * paddingFactor;

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
    // 3. PONTOS
    // -------------------------------------------------
    final count = close.length;
    final dx = count > 1 ? usableWidth / (count - 1) : 0.0;

    List<Offset> buildPoints(List<double> series) {
      return List.generate(series.length, (i) {
        final x = chartLeft + i * dx;
        final y = valueToY(series[i]);
        return Offset(x, y);
      });
    }

    final openPoints = showOpen ? buildPoints(open) : <Offset>[];
    final highPoints = showHigh ? buildPoints(high) : <Offset>[];
    final lowPoints = showLow ? buildPoints(low) : <Offset>[];
    final closePoints = showClose ? buildPoints(close) : <Offset>[];

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
    // 5. LABELS EIXO X
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
    // 6. TOOLTIP SERIES (para hover)
    // -------------------------------------------------
    final tooltipSeries = <TooltipSeries>[];

    if (showOpen) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Open",
          color: openColor,
          values: open,
        ),
      );
    }
    if (showHigh) {
      tooltipSeries.add(
        TooltipSeries(
          label: "High",
          color: highColor,
          values: high,
        ),
      );
    }
    if (showLow) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Low",
          color: lowColor,
          values: low,
        ),
      );
    }
    if (showClose) {
      tooltipSeries.add(
        TooltipSeries(
          label: "Close",
          color: closeColor,
          values: close,
        ),
      );
    }

    final List<Offset> basePoints;

    if (closePoints.isNotEmpty) {
      basePoints = closePoints;
    } else if (openPoints.isNotEmpty) {
      basePoints = openPoints;
    } else if (highPoints.isNotEmpty) {
      basePoints = highPoints;
    } else if (lowPoints.isNotEmpty) {
      basePoints = lowPoints;
    } else {
      // Se nenhuma série estiver ativa, criar pontos base apenas para posicionamento X do hover
      // Usa close para calcular posições X, mas não desenha a linha
      basePoints = buildPoints(close);
    }

    return CanvasLineChartData(
      openPoints: openPoints,
      highPoints: highPoints,
      lowPoints: lowPoints,
      closePoints: closePoints,
      // points: closePoints,
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
      points: basePoints,
    );
  }
}
