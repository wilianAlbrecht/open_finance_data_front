import 'dart:math';
import 'package:flutter/material.dart';

class CanvasLineChartData {
  final List<Offset> points; // pontos da linha completamente calculados
  final List<double> close;

  // Área útil do gráfico (com paddings aplicados)
  final double chartLeft;
  final double chartRight;
  final double chartTop;
  final double chartBottom;

  final List<String> fullXLabels; // novo

  // Valores mínimos e máximos
  final double minValue;
  final double maxValue;

  // Linhas de grid horizontal
  final List<double> gridY; // posições Y
  final List<double> gridValues; // valores representados nessas linhas

  // Posições X para labels
  final List<double> labelX; // posições X
  final List<int> labelIndexes; // índice correspondente

  final List<String> yLabels;
  final List<String> xLabels;

  CanvasLineChartData({
    required this.points,
    required this.close,
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
  });
}

class CanvasLineChartBuilder {
  final List<double> close;
  final List<int> timestamp;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double chartWidth;
  final double chartHeight;

  CanvasLineChartBuilder({
    required this.close,
    required this.timestamp,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.chartWidth,
    required this.chartHeight,
  });

  // ============================================================
  // MAIN BUILD METHOD
  // ============================================================
  CanvasLineChartData build() {
    final values = close;

    // 1. MIN/MAX
    double minValue = values.reduce(min);
    double maxValue = values.reduce(max);

    // aplica padding vertical (15% do range)
    double range = maxValue - minValue;
    final paddingFactor = 0.15;

    minValue = minValue - range * paddingFactor;
    maxValue = maxValue + range * paddingFactor;

    // 2. ÁREA ÚTIL DO GRÁFICO
    final chartLeft = paddingLeft;
    final chartRight = chartWidth - paddingRight;
    final chartTop = paddingTop;
    final chartBottom = chartHeight - paddingBottom;

    final usableHeight = chartBottom - chartTop;
    final usableWidth = chartRight - chartLeft;

    // 3. RANGE
    range = maxValue - minValue;

    // 4. NORMALIZAÇÃO E CONVERSÃO PARA COORDENADA Y
    double valueToY(double v) {
      final normalized = (v - minValue) / range;
      return chartBottom - (normalized * usableHeight);
    }

    // 5. CÁLCULO DE X (espaçamento uniforme)
    final count = values.length;
    final dx = count > 1 ? usableWidth / (count - 1) : 0.0;

    // Construir lista de pontos
    final List<Offset> points = [];
    for (int i = 0; i < count; i++) {
      final x = chartLeft + i * dx;
      final y = valueToY(values[i]);
      points.add(Offset(x, y));
    }

    // 6. GRID HORIZONTAL (5 linhas)
    const int gridLines = 5;
    final List<double> gridValues = [];
    final List<double> gridY = [];

    // Y LABELS formatados
    final List<String> yLabels = gridValues
        .map((v) => v.toStringAsFixed(2))
        .toList();

    for (int i = 0; i <= gridLines; i++) {
      final gv = minValue + (range / gridLines) * i;
      gridValues.add(gv);
      gridY.add(valueToY(gv));
    }

    // 7. LABELS DO EIXO X (6 valores)
    const labelCount = 6;
    final List<double> labelX = [];
    final List<int> labelIndexes = [];

    if (count > 0) {
      final step = (count / labelCount).floor();
      for (int i = 0; i < count; i += step) {
        labelIndexes.add(i);
        labelX.add(chartLeft + i * dx);
      }
    }

    final List<String> xLabels = labelIndexes.map((i) {
      final ts = timestamp[i];
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString().padLeft(2,"0");

      return "$day/$month/$year";
    }).toList();

    final List<String> fullXLabels = [];

    for (int i = 0; i < timestamp.length; i++) {
      final ts = timestamp[i];
      final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString().padLeft(2,"0");

      fullXLabels.add("$day/$month/$year");
    }

    return CanvasLineChartData(
      points: points,
      close: values,
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
    );
  }
}
