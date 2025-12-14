import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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

  final ValueChanged<bool>? onHoverScrollLock;

  final bool showOpen;
  final bool showHigh;
  final bool showLow;
  final bool showClose;

  const CanvasChartWidget({
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
    this.onHoverScrollLock,
  });

  @override
  State<CanvasChartWidget> createState() => _CanvasChartWidgetState();
}

class _CanvasChartWidgetState extends State<CanvasChartWidget> {
  int? hoveredIndex;
  Offset? hoveredPosition;

  CanvasLineChartBuilder? _priceBuilder;

  // PAN state
  double? _lastDragX;
  double _panPixelRemainder = 0.0;

  // ------------------------------------------------------------
  // 🔄 SINCRONIZA FILTROS OHLC (CRÍTICO)
  // ------------------------------------------------------------
  @override
  void didUpdateWidget(covariant CanvasChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_priceBuilder == null) return;

    final filtersChanged =
        oldWidget.showOpen != widget.showOpen ||
        oldWidget.showHigh != widget.showHigh ||
        oldWidget.showLow != widget.showLow ||
        oldWidget.showClose != widget.showClose;

    if (filtersChanged) {
      setState(() {
        _priceBuilder!
          ..showOpen = widget.showOpen
          ..showHigh = widget.showHigh
          ..showLow = widget.showLow
          ..showClose = widget.showClose;
      });
    }
  }

  // ------------------------------------------------------------
  // 🔍 ZOOM (SCROLL)
  // ------------------------------------------------------------
  void _onScrollZoom(PointerScrollEvent event) {
    if (widget.chartMode != ChartMode.price) return;
    if (_priceBuilder == null) return;

    const zoomStep = 0.2;

    setState(() {
      if (event.scrollDelta.dy < 0) {
        _priceBuilder!.zoom += zoomStep;
      } else {
        _priceBuilder!.zoom -= zoomStep;
      }

      _priceBuilder!.zoom = _priceBuilder!.zoom.clamp(
        _priceBuilder!.minZoom,
        _priceBuilder!.maxZoom,
      );
    });
  }

  // ------------------------------------------------------------
  // ✋ PAN (DRAG)
  // ------------------------------------------------------------
  void _onPanStart(DragStartDetails details) {
    _lastDragX = details.localPosition.dx;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_priceBuilder == null) return;
    if (widget.chartMode != ChartMode.price) return;

    final dx =
        details.localPosition.dx - (_lastDragX ?? details.localPosition.dx);
    _lastDragX = details.localPosition.dx;

    final usableWidth =
        _priceBuilder!.chartWidth -
        _priceBuilder!.paddingLeft -
        _priceBuilder!.paddingRight;

    final visibleCount = (widget.close.length / _priceBuilder!.zoom).clamp(
      10,
      widget.close.length,
    );

    final pixelsPerPoint = usableWidth / visibleCount;
    if (pixelsPerPoint <= 0) return;

    _panPixelRemainder += dx;

    final deltaPoints = (_panPixelRemainder / pixelsPerPoint).floor();

    if (deltaPoints != 0) {
      _panPixelRemainder -= deltaPoints * pixelsPerPoint;

      setState(() {
        // 🔄 direção invertida (como você pediu)
        _priceBuilder!.panOffset += deltaPoints;

        _priceBuilder!.panOffset = _priceBuilder!.panOffset.clamp(
          0,
          widget.close.length,
        );
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    _lastDragX = null;
    _panPixelRemainder = 0.0;
  }

  // ------------------------------------------------------------
  // INIT BUILDER
  // ------------------------------------------------------------
  void _initPriceBuilder(BuildContext context, double w, double h) {
    _priceBuilder = CanvasLineChartBuilder(
      open: widget.open,
      high: widget.high,
      low: widget.low,
      close: widget.close,
      showOpen: widget.showOpen,
      showHigh: widget.showHigh,
      showLow: widget.showLow,
      showClose: widget.showClose,
      timestamp: widget.timestamp,
      paddingLeft: 58,
      paddingRight: 25,
      paddingTop: 18,
      paddingBottom: 35,
      chartWidth: w,
      chartHeight: h,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final canvas = pkg.canvas;

    final chartWidth = MediaQuery.of(context).size.width * canvas.widthFactor;
    final chartHeight =
        MediaQuery.of(context).size.height * canvas.heightFactor;

    dynamic chartData;
    CustomPainter painter;

    final showAnySeries =
        widget.showOpen ||
        widget.showHigh ||
        widget.showLow ||
        widget.showClose;

    // =========================
    // MODO PREÇO
    // =========================
    if (widget.chartMode == ChartMode.price) {
      if (_priceBuilder == null ||
          _priceBuilder!.chartWidth != chartWidth ||
          _priceBuilder!.chartHeight != chartHeight) {
        _initPriceBuilder(context, chartWidth, chartHeight);
      }

      chartData = _priceBuilder!.build();

      painter = CanvasLinePainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,
        themePkg: pkg,
        timestamp: widget.timestamp,
      );
    }
    // =========================
    // MODO VOLUME
    // =========================
    else {
      final builder = CanvasMountainChartBuilder(
        volume: widget.volume,
        timestamp: widget.timestamp,
        paddingLeft: 58,
        paddingRight: 25,
        paddingTop: 18,
        paddingBottom: 35,
        chartWidth: chartWidth,
        chartHeight: chartHeight,
      );

      chartData = builder.build();

      painter = CanvasMountainPainter(
        data: chartData,
        hoveredIndex: hoveredIndex,
        hoveredPosition: hoveredPosition,
        themePkg: pkg,
      );
    }

    // =========================
    // WIDGET FINAL
    // =========================
    return SizedBox(
      width: chartWidth,
      height: chartHeight,
      child: MouseRegion(
        onEnter: (_) {
          // 🔒 trava o scroll da página
          widget.onHoverScrollLock?.call(true);
        },
        onExit: (_) {
          // 🔓 libera o scroll da página
          widget.onHoverScrollLock?.call(false);

          setState(() {
            hoveredIndex = null;
            hoveredPosition = null;
          });
        },
        onHover: (event) {
          if (widget.chartMode == ChartMode.price && !showAnySeries) return;

          final pos = event.localPosition;
          final index = _getNearestPointIndex(pos, chartData);

          setState(() {
            hoveredPosition = pos;
            hoveredIndex = index;
          });
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Listener(
            onPointerSignal: (signal) {
              if (signal is PointerScrollEvent) {
                _onScrollZoom(signal);
              }
            },
            child: CustomPaint(painter: painter),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // PONTO MAIS PRÓXIMO
  // ------------------------------------------------------------
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
