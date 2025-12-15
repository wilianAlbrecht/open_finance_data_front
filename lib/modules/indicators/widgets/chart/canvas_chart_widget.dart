import 'dart:math';

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
  CanvasMountainChartBuilder? _volumeBuilder;

  // PAN state
  double? _lastDragX;
  double _panPixelRemainder = 0.0;

  // ------------------------------------------------------------
  // 🔄 SINCRONIZA FILTROS OHLC (CRÍTICO)
  // ------------------------------------------------------------
  @override
  void didUpdateWidget(covariant CanvasChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final dataChanged =
        oldWidget.timestamp != widget.timestamp ||
        oldWidget.open != widget.open ||
        oldWidget.high != widget.high ||
        oldWidget.low != widget.low ||
        oldWidget.close != widget.close ||
        oldWidget.volume != widget.volume ||
        oldWidget.chartMode != widget.chartMode;

    final visibilityChanged =
        oldWidget.showOpen != widget.showOpen ||
        oldWidget.showHigh != widget.showHigh ||
        oldWidget.showLow != widget.showLow ||
        oldWidget.showClose != widget.showClose;

    if (dataChanged || visibilityChanged) {
      _priceBuilder = null;
      _volumeBuilder = null;
    }
  }

  // ------------------------------------------------------------
  // 🔍 ZOOM (SCROLL)
  // ------------------------------------------------------------
  void _onScrollZoom(PointerScrollEvent event) {
    if (hoveredPosition == null) return;

    const zoomStep = 0.25;
    final delta = event.scrollDelta.dy < 0 ? zoomStep : -zoomStep;

    setState(() {
      if (widget.chartMode == ChartMode.price && _priceBuilder != null) {
        _applyZoomCentered(
          deltaZoom: delta,
          mouseX: hoveredPosition!.dx,
          chartLeft: _priceBuilder!.paddingLeft,
          chartRight: _priceBuilder!.chartWidth - _priceBuilder!.paddingRight,
          totalCount: widget.close.length,
          currentZoom: _priceBuilder!.zoom,
          minZoom: _priceBuilder!.minZoom,
          maxZoom: _priceBuilder!.maxZoom,
          getPan: () => _priceBuilder!.panOffset.toDouble(),
          setPan: (v) => _priceBuilder!.panOffset = -v.toInt(),
          setZoom: (v) => _priceBuilder!.zoom = v,
        );
      }

      if (widget.chartMode == ChartMode.volume && _volumeBuilder != null) {
        _applyZoomCentered(
          deltaZoom: delta,
          mouseX: hoveredPosition!.dx,
          chartLeft: _volumeBuilder!.paddingLeft,
          chartRight: _volumeBuilder!.chartWidth - _volumeBuilder!.paddingRight,
          totalCount: widget.volume.length,
          currentZoom: _volumeBuilder!.zoom,
          minZoom: _volumeBuilder!.minZoom,
          maxZoom: _volumeBuilder!.maxZoom,
          getPan: () => _volumeBuilder!.panOffset,
          setPan: (v) => _volumeBuilder!.panOffset = v,
          setZoom: (v) => _volumeBuilder!.zoom = v,
        );
      }
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
    if (widget.chartMode == ChartMode.price) {
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
          _priceBuilder!.panOffset += deltaPoints;

          _priceBuilder!.panOffset = _priceBuilder!.panOffset.clamp(
            0,
            widget.close.length,
          );
        });
      }
    } else if (widget.chartMode == ChartMode.volume) {
      if (_volumeBuilder == null) return;

      final dx =
          details.localPosition.dx - (_lastDragX ?? details.localPosition.dx);
      _lastDragX = details.localPosition.dx;

      final usableWidth =
          _volumeBuilder!.chartWidth -
          _volumeBuilder!.paddingLeft -
          _volumeBuilder!.paddingRight;

      final visibleCount = (widget.volume.length / _volumeBuilder!.zoom).clamp(
        10,
        widget.volume.length,
      );

      final pixelsPerPoint = usableWidth / visibleCount;
      if (pixelsPerPoint <= 0) return;

      _panPixelRemainder += dx;

      final deltaPoints = (_panPixelRemainder / pixelsPerPoint).floor();

      if (deltaPoints == 0) return;

      _panPixelRemainder -= deltaPoints * pixelsPerPoint;

      setState(() {
        _volumeBuilder!.panOffset -= deltaPoints;
        final totalCount = widget.volume.length;
        final visibleCount = (totalCount / _volumeBuilder!.zoom).clamp(
          10,
          totalCount,
        );

        final maxPan = max(0, totalCount - visibleCount);

        _volumeBuilder!.panOffset = _volumeBuilder!.panOffset.clamp(
          0,
          maxPan.toDouble(),
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
    // ESTADO INICIAL (SEM BUSCA)
    // =========================
    if (widget.timestamp.isEmpty) {
      return SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: const Center(
          child: Text(
            'Pesquise um ativo para visualizar o gráfico',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // =========================
    // GUARDA DE DADOS
    // =========================
    final int dataLength = widget.timestamp.length;

    if (dataLength < 2) {
      return SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
      if (_volumeBuilder == null ||
          _volumeBuilder!.chartWidth != chartWidth ||
          _volumeBuilder!.chartHeight != chartHeight) {
        _volumeBuilder = CanvasMountainChartBuilder(
          volume: widget.volume,
          timestamp: widget.timestamp,
          paddingLeft: 58,
          paddingRight: 25,
          paddingTop: 18,
          paddingBottom: 35,
          chartWidth: chartWidth,
          chartHeight: chartHeight,
        );
      }

      chartData = _volumeBuilder!.build();

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

  void _applyZoomCentered({
    required double deltaZoom,
    required double mouseX,
    required double chartLeft,
    required double chartRight,
    required int totalCount,
    required double currentZoom,
    required double minZoom,
    required double maxZoom,
    required double Function() getPan,
    required void Function(double) setPan,
    required void Function(double) setZoom,
  }) {
    final usableWidth = chartRight - chartLeft;
    if (usableWidth <= 0) return;

    final oldZoom = currentZoom;
    final newZoom = (currentZoom + deltaZoom).clamp(minZoom, maxZoom);

    if (oldZoom == newZoom) return;

    final oldVisible = (totalCount / oldZoom).clamp(10, totalCount);

    final newVisible = (totalCount / newZoom).clamp(10, totalCount);

    final ratio = ((mouseX - chartLeft) / usableWidth).clamp(0.0, 1.0);

    final hoveredIndex = getPan() + ratio * oldVisible;

    final newPan = hoveredIndex - (1 - ratio) * newVisible;

    setZoom(newZoom);
    setPan(newPan);
  }
}
