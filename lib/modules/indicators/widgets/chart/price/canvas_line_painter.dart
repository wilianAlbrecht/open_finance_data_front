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
    // GRID PAINT
    final gridPaint = Paint()
      ..color = baseTheme.gridColor
      ..strokeWidth = baseTheme.gridStrokeWidth;

    // AXIS PAINT
    final axisPaint = Paint()
      ..color = baseTheme.axisColor
      ..strokeWidth = baseTheme.axisStrokeWidth;

    // HOVER LINE
    final hoverLinePaint = Paint()
      ..color = baseTheme.hoverLineColor
      ..strokeWidth = baseTheme.hoverLineWidth;

    // HOVER POINT
    final hoverPointPaint = Paint()
      ..color = baseTheme.hoverPointColor
      ..style = PaintingStyle.fill;

    // ============================================================
    // 1. GRID HORIZONTAL
    // ============================================================
    for (final y in data.gridY) {
      canvas.drawLine(
        Offset(data.chartLeft, y),
        Offset(data.chartRight, y),
        gridPaint,
      );
    }

    // ============================================================
    // 1.5. GRID VERTICAL
    // ============================================================
    for (final x in data.labelX) {
      canvas.drawLine(
        Offset(x, data.chartTop),
        Offset(x, data.chartBottom),
        gridPaint,
      );
    }

    // ============================================================
    // 2. EIXOS
    // ============================================================
    canvas.drawLine(
      Offset(data.chartLeft, data.chartBottom),
      Offset(data.chartRight, data.chartBottom),
      axisPaint,
    );

    canvas.drawLine(
      Offset(data.chartLeft, data.chartTop),
      Offset(data.chartLeft, data.chartBottom),
      axisPaint,
    );

    // ============================================================
    // 3. LABELS EIXO X
    // ============================================================
    for (int i = 0; i < data.xLabels.length; i++) {
      final x = data.labelX[i];
      final text = data.xLabels[i];

      final tp = TextPainter(
        text: TextSpan(text: text, style: baseTheme.labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x - tp.width / 2, data.chartBottom + 4));
    }

    // ============================================================
    // 4. LABELS EIXO Y
    // ============================================================
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
        Offset(data.chartLeft - tp.width - 6, y - tp.height / 2),
      );
    }

    // ============================================================
    // 5. DRAW MULTIPLE SERIES
    // ============================================================
    _drawSeries(canvas, data.openPoints, baseTheme.openColor);
    _drawSeries(canvas, data.highPoints, baseTheme.highColor);
    _drawSeries(canvas, data.lowPoints, baseTheme.lowColor);
    _drawSeries(canvas, data.closePoints, baseTheme.closeColor);

    // ============================================================
    // 6. HOVER
    // ============================================================
    // Só processa hover se houver séries ativas
    if (hoveredPosition != null && hoveredIndex != null && data.tooltipSeries.isNotEmpty) {
      final i = hoveredIndex!;
      if (i >= 0 && i < data.points.length) {
        final point = data.points[i];

        // Linha vertical
        canvas.drawLine(
          Offset(point.dx, data.chartTop),
          Offset(point.dx, data.chartBottom),
          hoverLinePaint,
        );

        // Desenhar pontos em todas as séries visíveis
        // Open
        if (i < data.openPoints.length) {
          final pointPaint = Paint()
            ..color = baseTheme.openColor
            ..style = PaintingStyle.fill;
          canvas.drawCircle(data.openPoints[i], baseTheme.hoverPointRadius, pointPaint);
        }

        // High
        if (i < data.highPoints.length) {
          final pointPaint = Paint()
            ..color = baseTheme.highColor
            ..style = PaintingStyle.fill;
          canvas.drawCircle(data.highPoints[i], baseTheme.hoverPointRadius, pointPaint);
        }

        // Low
        if (i < data.lowPoints.length) {
          final pointPaint = Paint()
            ..color = baseTheme.lowColor
            ..style = PaintingStyle.fill;
          canvas.drawCircle(data.lowPoints[i], baseTheme.hoverPointRadius, pointPaint);
        }

        // Close
        if (i < data.closePoints.length) {
          final pointPaint = Paint()
            ..color = baseTheme.closeColor
            ..style = PaintingStyle.fill;
          canvas.drawCircle(data.closePoints[i], baseTheme.hoverPointRadius, pointPaint);
        }

        // Tooltip com valores (só se houver séries ativas)
        if (data.tooltipSeries.isNotEmpty) {
          _drawTooltip(canvas, point, i);
        }

        // -------------- DRAW HOVER DATE --------------
        // Só desenha a data do hover se não houver uma data fixa nessa posição
        if (!data.labelIndexes.contains(i)) {
          final hoverDate = data.fullXLabels[i];

          final tp = TextPainter(
            text: TextSpan(text: hoverDate, style: baseTheme.labelStyle),
            textDirection: TextDirection.ltr,
          )..layout();

          // Verificar se há sobreposição com alguma data fixa
          bool hasOverlap = false;
          const overlapThreshold = 50.0; // distância mínima para considerar sobreposição
          
          for (final fixedX in data.labelX) {
            if ((point.dx - fixedX).abs() < overlapThreshold) {
              hasOverlap = true;
              break;
            }
          }

          // Se houver sobreposição, mover para baixo; caso contrário, manter no mesmo eixo
          final yPosition = hasOverlap 
              ? data.chartBottom + 20 // abaixo das datas fixas
              : data.chartBottom + 4; // mesmo eixo das datas fixas

          tp.paint(
            canvas,
            Offset(
              point.dx - tp.width / 2,
              yPosition,
            ),
          );
        }
      }
    }
  }

  // ============================================================
  // DRAW SINGLE SERIES
  // ============================================================
  void _drawSeries(Canvas canvas, List<Offset> points, Color color) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  // ============================================================
  // TOOLTIP
  // ============================================================
  void _drawTooltip(Canvas canvas, Offset point, int index) {
    final entries = <TextPainter>[];

    double maxWidth = 0;

    // Criar painters para cada linha do tooltip
    for (final s in data.tooltipSeries) {
      final value = s.values[index];
      final tp = TextPainter(
        text: TextSpan(
          text: "${s.label}: ${value.toStringAsFixed(2)}",
          style: baseTheme.tooltipStyle.copyWith(color: s.color),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      entries.add(tp);
      if (tp.width > maxWidth) maxWidth = tp.width;
    }

    const padding = 6.0;
    final rectWidth = maxWidth + padding * 2;
    final rectHeight =
        entries.length * (entries.first.height + 2) + padding * 2;

    final tooltipRect = Rect.fromLTWH(
      point.dx - rectWidth / 2,
      point.dy - rectHeight - 12,
      rectWidth,
      rectHeight,
    );

    final rrect = RRect.fromRectAndRadius(tooltipRect, Radius.circular(6));

    final bgPaint = Paint()..color = Colors.black.withOpacity(0.85);
    canvas.drawRRect(rrect, bgPaint);

    double dy = tooltipRect.top + padding;

    for (final tp in entries) {
      tp.paint(canvas, Offset(tooltipRect.left + padding, dy));
      dy += tp.height + 2;
    }
  }

  @override
  bool shouldRepaint(CanvasLinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.hoveredPosition != hoveredPosition;
  }
}
