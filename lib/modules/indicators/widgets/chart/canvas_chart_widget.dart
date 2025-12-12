import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';

import 'package:open_finance_data_front/modules/indicators/widgets/chart/chart_mode_selector.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/canvas_line_chart_builder.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/canvas_line_painter.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/volume/canvas_mountain_chart_builder.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/volume/canvas_mountain_painter.dart';

class CanvasChartWidget extends StatefulWidget {
  final ChartMode chartMode;

  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;
  final List<double> volume;
  final List<int> timestamp;

  bool showOpen = false;
  bool showHigh = false;
  bool showLow = false;
  bool showClose = true;

  CanvasChartWidget({
    super.key,
    required this.chartMode,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.timestamp,
    required this.showOpen,
    required this.showHigh,
    required this.showLow,
    required this.showClose,
  });

  @override
  State<CanvasChartWidget> createState() => _CanvasChartWidgetState();
}

class _CanvasChartWidgetState extends State<CanvasChartWidget> {
  int? hoveredIndex;
  Offset? hoveredPosition;

  @override
  Widget build(BuildContext context) {
    // ============================================================
    //       ACESSO AO PACOTE DE TEMA GLOBAL
    // ============================================================
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final canvas = pkg.canvas; // <-- tema plano

    final chartWidth =
        MediaQuery.of(context).size.width * canvas.widthFactor;
    final chartHeight =
        MediaQuery.of(context).size.height * canvas.heightFactor;

    // Como NÃO existe canvas.base, assumimos padding fixo
    const double paddingLeft = 58;
    const double paddingRight = 25;
    const double paddingTop = 18;
    const double paddingBottom = 35;

    // width/height fixos como antes (se desejar tornamos configuráveis depois)
    final screen = MediaQuery.of(context).size;
    // final chartWidth = screen.width * 1;
    // final chartHeight = screen.height * 0.40;

    dynamic chartData;
    CustomPainter painter;

    final showAnySeries =
        widget.showOpen ||
        widget.showHigh ||
        widget.showLow ||
        widget.showClose;

    // ============================================================
    //                       MODO PREÇO
    // ============================================================
    if (widget.chartMode == ChartMode.price) {
      final builder = CanvasLineChartBuilder(
        open: widget.open,
        high: widget.high,
        low: widget.low,
        close: widget.close,
        showOpen: widget.showOpen,
        showHigh: widget.showHigh,
        showLow: widget.showLow,
        showClose: widget.showClose,
        timestamp: widget.timestamp,
        paddingLeft: paddingLeft,
        paddingRight: paddingRight,
        paddingTop: paddingTop,
        paddingBottom: paddingBottom,
        chartWidth: chartWidth,
        chartHeight: chartHeight,
        context: context,
      );

      chartData = builder.build();

      painter = CanvasLinePainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,
        themePkg: pkg, // ⭐ novo
        timestamp: widget.timestamp,
      );
    }
    // ============================================================
    //                      MODO VOLUME
    // ============================================================
    else {
      final builder = CanvasMountainChartBuilder(
        volume: widget.volume,
        timestamp: widget.timestamp,
        paddingLeft: paddingLeft,
        paddingRight: paddingRight,
        paddingTop: paddingTop,
        paddingBottom: paddingBottom,
        chartWidth: chartWidth,
        chartHeight: chartHeight,
      );

      chartData = builder.build();

      painter = CanvasMountainPainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,

        // Tema plano
        themePkg: pkg,
      );
    }

    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: MouseRegion(
        onExit: (_) => setState(() {
          hoveredIndex = null;
          hoveredPosition = null;
        }),

        onHover: (event) {
          if (widget.chartMode == ChartMode.price && !showAnySeries) return;

          final pos = event.localPosition;
          final index = _getNearestPointIndex(pos, chartData);

          setState(() {
            hoveredPosition = pos;
            hoveredIndex = index;
          });
        },

        child: Listener(
          onPointerDown: (event) {
            final pos = event.localPosition;
            final index = _getNearestPointIndex(pos, chartData);

            setState(() {
              hoveredPosition = pos;
              hoveredIndex = index;
            });
          },
          child: CustomPaint(painter: painter),
        ),
      ),
    );
  }

  // ============================================================
  // CÁLCULO DO PONTO MAIS PRÓXIMO
  // ============================================================
  int? _getNearestPointIndex(Offset hoverPos, dynamic data) {
    late final List<Offset> points;

    if (data is CanvasLineChartData) {
      points = data.points;
    } else if (data is CanvasMountainChartData) {
      points = data.topPoints;
    } else {
      return null;
    }

    double minDist = double.infinity;
    int? nearest;

    for (int i = 0; i < points.length; i++) {
      final dx = (points[i].dx - hoverPos.dx).abs();
      if (dx < minDist) {
        minDist = dx;
        nearest = i;
      }
    }

    return nearest;
  }
}
