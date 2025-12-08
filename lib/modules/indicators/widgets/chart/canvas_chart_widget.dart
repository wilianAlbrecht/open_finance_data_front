import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_base_theme.dart';
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
    final baseTheme = Theme.of(context).extension<AppCanvasBaseTheme>()!;
    final screen = MediaQuery.of(context).size;

    final chartWidth = screen.width * baseTheme.widthFactor;
    final chartHeight = screen.height * baseTheme.heightFactor;

    dynamic chartData;
    CustomPainter painter;

    // ===============================
    // BUILD DATA BASEADO NO MODO
    // ===============================
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
        paddingLeft: baseTheme.paddingLeft,
        paddingRight: baseTheme.paddingRight,
        paddingTop: baseTheme.paddingTop,
        paddingBottom: baseTheme.paddingBottom,
        chartWidth: chartWidth,
        chartHeight: chartHeight,
        context: context,
      );

      chartData = builder.build();

      painter = CanvasLinePainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,
        baseTheme: baseTheme,
        timestamp: widget.timestamp,
      );
    } else {
      final builder = CanvasMountainChartBuilder(
        volume: widget.volume,
        timestamp: widget.timestamp,
        paddingLeft: baseTheme.paddingLeft,
        paddingRight: baseTheme.paddingRight,
        paddingTop: baseTheme.paddingTop,
        paddingBottom: baseTheme.paddingBottom,
        chartWidth: chartWidth,
        chartHeight: chartHeight,
      );

      chartData = builder.build();

      painter = CanvasMountainPainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,
        baseTheme: baseTheme,
      );
    }

    // =====================================
    // SÉRIES ATIVAS (APENAS PARA PREÇO)
    // =====================================
    final hasActiveSeries =
        widget.showOpen ||
        widget.showHigh ||
        widget.showLow ||
        widget.showClose;

    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: MouseRegion(
        onExit: (_) {
          if (!mounted) return;
          setState(() {
            hoveredIndex = null;
            hoveredPosition = null;
          });
        },

        // ======================================================
        // HOVER — FUNCIONA EM AMBOS OS MODOS
        // ======================================================
        onHover: (event) {
          if (widget.chartMode == ChartMode.price && !hasActiveSeries) return;

          final pos = event.localPosition;
          final index = _getNearestPointIndex(pos, chartData);

          if (!mounted) return;
          setState(() {
            hoveredPosition = pos;
            hoveredIndex = index;
          });
        },

        child: Listener(
          onPointerDown: (event) {
            final pos = event.localPosition;
            final index = _getNearestPointIndex(pos, chartData);

            if (!mounted) return;
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
  // CÁLCULO DO PONTO MAIS PRÓXIMO (PRICE OU VOLUME)
  // ============================================================
  int? _getNearestPointIndex(Offset hoverPos, dynamic data) {
    late final List<Offset> points;

    if (data is CanvasLineChartData) {
      points = data.points; // gráfico de linha
    } else if (data is CanvasMountainChartData) {
      points = data.topPoints; // gráfico de volume
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

  @override
  void dispose() {
    hoveredIndex = null;
    hoveredPosition = null;
    super.dispose();
  }
}
