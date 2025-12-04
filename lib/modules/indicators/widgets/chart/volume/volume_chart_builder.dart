import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VolumeChartBuilder {
  final List<double> volume;
  final List<int> timestamp;

  VolumeChartBuilder({
    required this.volume,
    required this.timestamp,
  });

  /// 1) Barras do gráfico (somente dado visual)
  List<BarChartGroupData> buildBars(Color color) {
    return List.generate(volume.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            fromY: 0.0,
            toY: volume[i],
            width: 5.0,
            color: color,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

  /// 2) Valor máximo do gráfico (com folga)
  double getMaxVolume() {
    if (volume.isEmpty) return 0.0;
    final maxVal = volume.reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.2).toDouble();
  }

  /// 3) Step para dividir o eixo X em ~6 partes
  int getStep() {
    if (timestamp.isEmpty) return 1;
    final raw = (timestamp.length / 6).floor();
    return raw <= 0 ? 1 : raw;
  }

  /// 4) Verifica se um índice é válido
  bool isValidIndex(int index) {
    return index >= 0 && index < timestamp.length;
  }

  /// 5) Diz se este índice é uma divisão principal
  bool isDivisionIndex(int index) {
    final step = getStep();
    return step > 0 && index % step == 0;
  }

  /// 6) Formata label de data para o eixo X
  String formatDateLabel(int index) {
    final ts = timestamp[index];
    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString().padLeft(2, '0');

    return "$d/$m/$y";
  }

  /// 7) Formata valor de volume para o eixo Y
  String formatVolume(double value) {
    if (value >= 1_000_000) {
      return "${(value / 1_000_000).toStringAsFixed(1)}M";
    }
    if (value >= 1_000) {
      return "${(value / 1_000).toStringAsFixed(1)}K";
    }
    return value.toStringAsFixed(0);
  }
}
