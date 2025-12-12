import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_theme.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'canvas_line_chart_builder.dart';

class CanvasLinePainter extends CustomPainter {
  final CanvasLineChartData data;
  final int? hoveredIndex;
  final Offset? hoveredPosition;
  final AppThemePackage themePkg;
  final List<int> timestamp;

  CanvasLinePainter({
    required this.data,
    required this.hoveredIndex,
    required this.hoveredPosition,
    required this.themePkg,
    required this.timestamp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // TEMA GLOBAL
    final canvasTheme = themePkg.canvas;
    final textTheme = themePkg.text;

    // Cores
    final gridColor = canvasTheme.gridColor;
    final axisColor = canvasTheme.axisTextColor;
    final openColor = canvasTheme.openColor;
    final highColor = canvasTheme.highColor;
    final lowColor = canvasTheme.lowColor;
    final closeColor = canvasTheme.closeColor;

    // Tipografias (fallbacks com copyWith para tamanhos específicos)
    final labelStyle = textTheme.body;
    final tooltipStyle = textTheme.body;

    // PAINTS
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;
    final hoverLinePaint = Paint()
      ..color = axisColor.withOpacity(.7)
      ..strokeWidth = 1;
    final hoverPointPaint = Paint()
      ..color = axisColor
      ..style = PaintingStyle.fill;

    // 1. GRID HORIZONTAL
    for (final y in data.gridY) {
      canvas.drawLine(
        Offset(data.chartLeft, y),
        Offset(data.chartRight, y),
        gridPaint,
      );
    }

    // 1.5 GRID VERTICAL
    for (final x in data.labelX) {
      canvas.drawLine(
        Offset(x, data.chartTop),
        Offset(x, data.chartBottom),
        gridPaint,
      );
    }

    // 2. EIXOS
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

    // 3. LABELS EIXO X
    for (int i = 0; i < data.xLabels.length; i++) {
      final x = data.labelX[i];
      final text = data.xLabels[i];

      final tp = TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x - tp.width / 2, data.chartBottom + 4));
    }

    // 4. LABELS EIXO Y
    for (int i = 0; i < data.gridValues.length; i++) {
      final value = data.gridValues[i];
      final y = data.gridY[i];

      final tp = TextPainter(
        text: TextSpan(text: value.toStringAsFixed(2), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(data.chartLeft - tp.width - 6, y - tp.height / 2),
      );
    }

    // 5. SÉRIES
    _drawSeries(canvas, data.openPoints, openColor);
    _drawSeries(canvas, data.highPoints, highColor);
    _drawSeries(canvas, data.lowPoints, lowColor);
    _drawSeries(canvas, data.closePoints, closeColor);

    // 6. HOVER (se houver)
    if (hoveredPosition != null && hoveredIndex != null) {
      final i = hoveredIndex!;
      if (i >= 0 && i < data.points.length) {
        final point = data.points[i];

        // linha vertical
        canvas.drawLine(
          Offset(point.dx, data.chartTop),
          Offset(point.dx, data.chartBottom),
          hoverLinePaint,
        );

        // pontos nas séries visíveis
        if (i < data.openPoints.length) {
          canvas.drawCircle(data.openPoints[i], 4, Paint()..color = openColor);
        }
        if (i < data.highPoints.length) {
          canvas.drawCircle(data.highPoints[i], 4, Paint()..color = highColor);
        }
        if (i < data.lowPoints.length) {
          canvas.drawCircle(data.lowPoints[i], 4, Paint()..color = lowColor);
        }
        if (i < data.closePoints.length) {
          canvas.drawCircle(
            data.closePoints[i],
            4,
            Paint()..color = closeColor,
          );
        }

        // tooltip de valores (exemplo simples com close)
        _drawTooltip(canvas, point, i, tooltipStyle, canvasTheme);

        // data hover (somente se não for uma label fixa)
        if (!data.labelIndexes.contains(i)) {
          final hoverDate = data.fullXLabels[i];

          final tp = TextPainter(
            text: TextSpan(text: hoverDate, style: labelStyle),
            textDirection: TextDirection.ltr,
          )..layout();

          bool hasOverlap = false;
          const overlapThreshold = 50.0;
          for (final fixedX in data.labelX) {
            if ((point.dx - fixedX).abs() < overlapThreshold) {
              hasOverlap = true;
              break;
            }
          }

          final yPosition = hasOverlap
              ? data.chartBottom + 20
              : data.chartBottom + 4;
          tp.paint(canvas, Offset(point.dx - tp.width / 2, yPosition));
        }
      }
    }
  }

  void _drawSeries(Canvas canvas, List<Offset> points, Color color) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++)
      path.lineTo(points[i].dx, points[i].dy);
    canvas.drawPath(path, paint);
  }

  void _drawTooltip(
    Canvas canvas,
    Offset point,
    int index,
    TextStyle tooltipTextStyle,
    AppCanvasTheme canvasTheme,
  ) {
    final entries = <TextPainter>[];
    double maxWidth = 0;

    for (final s in data.tooltipSeries) {
      final value = s.values[index];

      final tp = TextPainter(
        text: TextSpan(
          text: "${s.label}: ${value.toStringAsFixed(2)}",
          style: tooltipTextStyle.copyWith(color: s.color),
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

    final rect = Rect.fromLTWH(
      point.dx - rectWidth / 2,
      point.dy - rectHeight - 16,
      rectWidth,
      rectHeight,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    canvas.drawRRect(rrect, Paint()..color = Colors.black.withOpacity(0.85));

    double offsetY = rect.top + padding;

    for (final tp in entries) {
      tp.paint(canvas, Offset(rect.left + padding, offsetY));
      offsetY += tp.height + 2;
    }
  }

  @override
  bool shouldRepaint(CanvasLinePainter old) =>
      old.data != data ||
      old.hoveredIndex != hoveredIndex ||
      old.hoveredPosition != hoveredPosition;
}
