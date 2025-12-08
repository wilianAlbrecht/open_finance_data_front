import 'dart:math';
import 'package:flutter/material.dart';

class CanvasMountainChartData {
  // Linha do topo da montanha
  final List<Offset> topPoints;

  // Paths prontos (builder calcula, painter só desenha)
  final Path fillPath;
  final Path strokePath;

  // Área útil do gráfico
  final double chartLeft;
  final double chartRight;
  final double chartTop;
  final double chartBottom;

  // Volume bruto (para tooltip, etc.)
  final List<double> volumes;

  // Labels completos (um por ponto) para hover
  final List<String> fullXLabels;

  // Grid Y (valor máximo dividido em 6)
  final double maxValue;
  final List<double> gridY;
  final List<double> gridValues;

  // Labels eixo X (apenas alguns pontos)
  final List<double> labelX;
  final List<int> labelIndexes;
  final List<String> xLabels;

  CanvasMountainChartData({
    required this.topPoints,
    required this.fillPath,
    required this.strokePath,
    required this.chartLeft,
    required this.chartRight,
    required this.chartTop,
    required this.chartBottom,
    required this.volumes,
    required this.fullXLabels,
    required this.maxValue,
    required this.gridY,
    required this.gridValues,
    required this.labelX,
    required this.labelIndexes,
    required this.xLabels,
  });
}

class CanvasMountainChartBuilder {
  final List<double> volume;
  final List<int> timestamp;

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final double chartWidth;
  final double chartHeight;

  CanvasMountainChartBuilder({
    required this.volume,
    required this.timestamp,
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.chartWidth,
    required this.chartHeight,
  });

  CanvasMountainChartData build() {
    if (volume.isEmpty || timestamp.isEmpty) {
      return CanvasMountainChartData(
        topPoints: const [],
        fillPath: Path(),
        strokePath: Path(),
        chartLeft: paddingLeft,
        chartRight: chartWidth - paddingRight,
        chartTop: paddingTop,
        chartBottom: chartHeight - paddingBottom,
        volumes: const [],
        fullXLabels: const [],
        maxValue: 0,
        gridY: const [],
        gridValues: const [],
        labelX: const [],
        labelIndexes: const [],
        xLabels: const [],
      );
    }

    // -------------------------------------------------
    // 1. Máximo de volume (base sempre zero)
    // -------------------------------------------------
    final double minVolume = volume.reduce(min);
    final double maxVolume = volume.reduce(max);

    // Base começa em 50% do menor volume
    final double baseVolume = minVolume * 0.5;

    // Ajustar valores caso min == max (evitar divisão 0)
    final adjustedMin = minVolume == maxVolume ? minVolume * 0.9 : baseVolume;

    final adjustedMax = maxVolume;

    // Aplica padding no topo (15%)
    double paddingFactor = 0.15;
    final double effectiveMax = adjustedMax * (1 + paddingFactor);

    // padding vertical no topo (ex.: 15%)
    paddingFactor = 0.15;
    final maxRange = maxVolume * (1 + paddingFactor);

    // -------------------------------------------------
    // 2. Área útil
    // -------------------------------------------------
    final chartLeft = paddingLeft;
    final chartRight = chartWidth - paddingRight;
    final chartTop = paddingTop;
    final chartBottom = chartHeight - paddingBottom;

    final usableHeight = chartBottom - chartTop;
    final usableWidth = chartRight - chartLeft;

    double valueToY(double v) {
      final normalized = (v - adjustedMin) / (effectiveMax - adjustedMin);
      return chartBottom - normalized * usableHeight;
    }

    // -------------------------------------------------
    // 3. Pontos do topo da montanha
    // -------------------------------------------------
    final count = volume.length;
    final dx = count > 1 ? usableWidth / (count - 1) : 0.0;

    final List<Offset> topPoints = List.generate(count, (i) {
      final x = chartLeft + i * dx;
      final y = valueToY(volume[i]);
      return Offset(x, y);
    });

    // -------------------------------------------------
    // 4. Paths (fill + stroke)
    // -------------------------------------------------
    final fillPath = Path();
    if (topPoints.isNotEmpty) {
      // começa na base esquerda
      fillPath.moveTo(chartLeft, chartBottom);
      // sobe pelo topo
      for (final p in topPoints) {
        fillPath.lineTo(p.dx, p.dy);
      }
      // desce para a base direita
      fillPath.lineTo(chartLeft + (count - 1) * dx, chartBottom);
      fillPath.close();
    }

    final strokePath = Path();
    if (topPoints.isNotEmpty) {
      strokePath.moveTo(topPoints.first.dx, topPoints.first.dy);
      for (int i = 1; i < topPoints.length; i++) {
        strokePath.lineTo(topPoints[i].dx, topPoints[i].dy);
      }
    }

    // -------------------------------------------------
    // 5. Grid Y (max dividido em 6)
    // -------------------------------------------------
    const int gridLines = 6;
    final List<double> gridValues = [];
    final List<double> gridY = [];

    for (int i = 0; i <= gridLines; i++) {
      final gv = maxVolume / gridLines * i;
      gridValues.add(gv);
      gridY.add(valueToY(gv));
    }

    // -------------------------------------------------
    // 6. Labels do eixo X (6 valores)
    // -------------------------------------------------
    const labelCount = 6;
    final List<double> labelX = [];
    final List<int> labelIndexes = [];

    if (count > 0) {
      final step = max(1, (count / labelCount).floor());
      for (int i = 0; i < count; i += step) {
        labelIndexes.add(i);
        final x = chartLeft + i * dx;
        labelX.add(x);
      }
    }

    final List<String> xLabels = labelIndexes.map((i) {
      final ts = timestamp[i];
      final dt = DateTime.fromMillisecondsSinceEpoch(
        ts * 1000,
        isUtc: true,
      ).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString();
      return '$day/$month/$year';
    }).toList();

    // labels completos (um por ponto) para hover
    final List<String> fullXLabels = timestamp.map((ts) {
      final dt = DateTime.fromMillisecondsSinceEpoch(
        ts * 1000,
        isUtc: true,
      ).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year.toString();
      return '$day/$month/$year';
    }).toList();

    return CanvasMountainChartData(
      topPoints: topPoints,
      fillPath: fillPath,
      strokePath: strokePath,
      chartLeft: chartLeft,
      chartRight: chartRight,
      chartTop: chartTop,
      chartBottom: chartBottom,
      volumes: volume,
      fullXLabels: fullXLabels,
      maxValue: maxVolume,
      gridY: gridY,
      gridValues: gridValues,
      labelX: labelX,
      labelIndexes: labelIndexes,
      xLabels: xLabels,
    );
  }
}
