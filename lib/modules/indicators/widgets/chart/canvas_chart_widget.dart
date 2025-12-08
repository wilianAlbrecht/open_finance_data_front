import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_base_theme.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/canvas_line_chart_builder.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/canvas_line_painter.dart';

class CanvasChartWidget extends StatefulWidget {
  final List<double> close;
  final List<int> timestamp;

  // Preparado para futuro
  final List<double>? open;
  final List<double>? high;
  final List<double>? low;

  const CanvasChartWidget({
    super.key,
    required this.close,
    required this.timestamp,
    this.open,
    this.high,
    this.low,
  });

  @override
  State<CanvasChartWidget> createState() => _CanvasChartWidgetState();
}

class _CanvasChartWidgetState extends State<CanvasChartWidget> {
  int? hoveredIndex;
  Offset? hoveredPosition;

  // -------------------------------
  // HANDLE HOVER (WEB)
  // -------------------------------
  void _handleHover(PointerHoverEvent event, Size chartSize) {
    setState(() {
      hoveredPosition = event.localPosition;
      // hoveredIndex será calculado pelo painter usando hoveredPosition
    });
  }

  // -------------------------------
  // HANDLE TAP (MOBILE)
  // -------------------------------
  void _handleTap(PointerDownEvent event, Size chartSize) {
    setState(() {
      hoveredPosition = event.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context).extension<AppCanvasBaseTheme>()!;
    final screen = MediaQuery.of(context).size;

    // -------------------------------
    // GRAPH SIZE FROM THE THEME
    // -------------------------------
    final chartWidth = screen.width * baseTheme.widthFactor;
    final chartHeight = screen.height * baseTheme.heightFactor;

    // -------------------------------
    // BUILD CHART DATA (only line now)
    // -------------------------------
    final builder = CanvasLineChartBuilder(
      close: widget.close,
      timestamp: widget.timestamp,
      // open/high/low serão usados no futuro
      paddingLeft: baseTheme.paddingLeft,
      paddingRight: baseTheme.paddingRight,
      paddingTop: baseTheme.paddingTop,
      paddingBottom: baseTheme.paddingBottom,
      chartWidth: chartWidth,
      chartHeight: chartHeight,
    );

    final data = builder.build();

    // -------------------------------
    // CREATE PAINTER
    // -------------------------------
    final painter = CanvasLinePainter(
      data: data,
      hoveredIndex: hoveredIndex,
      hoveredPosition: hoveredPosition,
      baseTheme: baseTheme,
      timestamp: widget.timestamp,
    );

    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: MouseRegion(
        onExit: (_) {
          setState(() {
            hoveredIndex = null;
            hoveredPosition = null;
          });
        },
        onHover: (event) {
          final localPos = event.localPosition;
          final index = _getNearestPointIndex(localPos, data);

          setState(() {
            hoveredPosition = localPos;
            hoveredIndex = index;
          });
        },
        child: Listener(
          onPointerDown: (event) {
            _handleTap(event, Size(chartWidth, chartHeight));
          },
          child: CustomPaint(painter: painter),
        ),
      ),
    );
  }

  int? _getNearestPointIndex(Offset hoverPos, CanvasLineChartData data) {
    double minDist = double.infinity;
    int? nearestIndex;

    for (int i = 0; i < data.points.length; i++) {
      final dx = (data.points[i].dx - hoverPos.dx).abs();
      if (dx < minDist) {
        minDist = dx;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }
}
