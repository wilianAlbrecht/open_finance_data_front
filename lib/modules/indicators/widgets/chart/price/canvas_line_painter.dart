import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_base_theme.dart';
import 'canvas_line_chart_builder.dart';

class CanvasLinePainter extends CustomPainter {
  final CanvasLineChartData data;
  final int? hoveredIndex;
  final Offset? hoveredPosition;
  final AppCanvasBaseTheme baseTheme;
  final List<int> timestamp;

  CanvasLinePainter({
    required this.data,
    required this.baseTheme,
    required this.hoveredIndex,
    required this.hoveredPosition,
    required this.timestamp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ============================================================
    // PREPARE PAINTS
    // ============================================================
    final gridPaint = Paint()
      ..color = baseTheme.gridColor
      ..strokeWidth = baseTheme.gridStrokeWidth;

    final axisPaint = Paint()
      ..color = baseTheme.axisColor
      ..strokeWidth = baseTheme.axisStrokeWidth;

    final linePaint = Paint()
      ..color = baseTheme.axisColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final hoverLinePaint = Paint()
      ..color = baseTheme.hoverLineColor
      ..strokeWidth = baseTheme.hoverLineWidth;

    final hoverPointPaint = Paint()
      ..color = baseTheme.hoverPointColor
      ..style = PaintingStyle.fill;

    // ============================================================
    // 1. DRAW GRID HORIZONTAL
    // ============================================================
    for (final y in data.gridY) {
      canvas.drawLine(
        Offset(data.chartLeft, y),
        Offset(data.chartRight, y),
        gridPaint,
      );
    }

    // ============================================================
    // 2. DRAW AXIS (BOTTOM & LEFT)
    // ============================================================
    // Eixo X (bottom)
    canvas.drawLine(
      Offset(data.chartLeft, data.chartBottom),
      Offset(data.chartRight, data.chartBottom),
      axisPaint,
    );

    // Eixo Y (left)
    canvas.drawLine(
      Offset(data.chartLeft, data.chartTop),
      Offset(data.chartLeft, data.chartBottom),
      axisPaint,
    );

    for (int i = 0; i < data.xLabels.length; i++) {
      final x = data.labelX[i];
      final text = data.xLabels[i]; // APENAS OS 6 LABELS DO EIXO X

      final tp = TextPainter(
        text: TextSpan(text: text, style: baseTheme.labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x - tp.width / 2, data.chartBottom + 4));
    }

    for (int i = 0; i < data.gridValues.length; i++) {
      final value = data.gridValues[i];
      final y = data.gridY[i];

      final tp = TextPainter(
        text: TextSpan(
          text: value.toStringAsFixed(2),
          style: baseTheme.labelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(
          data.chartLeft - tp.width - 6, // um pequeno espaçamento
          y - tp.height / 2,
        ),
      );
    }

    // ============================================================
    // 3. DRAW LINE (CLOSE SERIES)
    // ============================================================
    if (data.points.length > 1) {
      final path = Path()..moveTo(data.points.first.dx, data.points.first.dy);

      for (int i = 1; i < data.points.length; i++) {
        path.lineTo(data.points[i].dx, data.points[i].dy);
      }

      canvas.drawPath(path, linePaint);
    }

    // ============================================================
    // 4. DRAW HOVER
    // ============================================================
    if (hoveredPosition != null && hoveredIndex != null) {
      final i = hoveredIndex!;
      if (i >= 0 && i < data.points.length) {
        final point = data.points[i];

        // --- Hover vertical line ---
        canvas.drawLine(
          Offset(point.dx, data.chartTop),
          Offset(point.dx, data.chartBottom),
          hoverLinePaint,
        );

        // --- Hover point ---
        canvas.drawCircle(point, baseTheme.hoverPointRadius, hoverPointPaint);

        // --- Tooltip ---
        _drawTooltip(canvas, point, data.close[i]);
      }
    }
  }

  // ============================================================
  // DRAW TOOLTIP
  // ============================================================
  void _drawTooltip(Canvas canvas, Offset point, double value) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(2),
        style: baseTheme.tooltipStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final padding = 6.0;
    final rectWidth = textPainter.width + padding * 2;
    final rectHeight = textPainter.height + padding * 2;

    final tooltipRect = Rect.fromLTWH(
      point.dx - rectWidth / 2,
      point.dy - rectHeight - 12,
      rectWidth,
      rectHeight,
    );

    final rrect = RRect.fromRectAndRadius(tooltipRect, Radius.circular(6));

    final bgPaint = Paint()..color = Colors.black.withOpacity(0.80);

    canvas.drawRRect(rrect, bgPaint);
    textPainter.paint(
      canvas,
      Offset(tooltipRect.left + padding, tooltipRect.top + padding),
    );

    final hoverDate = data.fullXLabels[hoveredIndex!];

    final tp = TextPainter(
      text: TextSpan(text: hoverDate, style: baseTheme.labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(point.dx - tp.width / 2, data.chartBottom + 20));
  }

  @override
  bool shouldRepaint(CanvasLinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.hoveredPosition != hoveredPosition;
  }
}
