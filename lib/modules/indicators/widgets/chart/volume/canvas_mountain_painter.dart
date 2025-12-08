import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_canvas_base_theme.dart';
import 'canvas_mountain_chart_builder.dart';

class CanvasMountainPainter extends CustomPainter {
  final CanvasMountainChartData data;
  final int? hoveredIndex;
  final Offset? hoveredPosition;
  final AppCanvasBaseTheme baseTheme;

  CanvasMountainPainter({
    required this.data,
    required this.baseTheme,
    required this.hoveredIndex,
    required this.hoveredPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // -------------------------------------------------
    // PREPARE PAINTS
    // -------------------------------------------------
    final gridPaint = Paint()
      ..color = baseTheme.gridColor
      ..strokeWidth = baseTheme.gridStrokeWidth;

    final axisPaint = Paint()
      ..color = baseTheme.axisColor
      ..strokeWidth = baseTheme.axisStrokeWidth;

    // Montanha: preenchimento azul com degradê
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [
              Color(0xFF1E88E5), // topo mais forte
              Color(0x331E88E5), // meio mais claro
              Color(0x111E88E5), // base bem clara
            ],
          ).createShader(
            Rect.fromLTRB(
              data.chartLeft,
              data.chartTop,
              data.chartRight,
              data.chartBottom,
            ),
          );

    // Borda do topo da montanha
    final strokePaint = Paint()
      ..color = const Color(0xFF1E88E5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final hoverLinePaint = Paint()
      ..color = baseTheme.hoverLineColor
      ..strokeWidth = baseTheme.hoverLineWidth;

    final hoverPointPaint = Paint()
      ..color = baseTheme.hoverPointColor
      ..style = PaintingStyle.fill;

    // -------------------------------------------------
    // 1. GRID HORIZONTAL
    // -------------------------------------------------
    for (final y in data.gridY) {
      canvas.drawLine(
        Offset(data.chartLeft, y),
        Offset(data.chartRight, y),
        gridPaint,
      );
    }

    // -------------------------------------------------
    // 2. EIXOS
    // -------------------------------------------------
    // Eixo X
    canvas.drawLine(
      Offset(data.chartLeft, data.chartBottom),
      Offset(data.chartRight, data.chartBottom),
      axisPaint,
    );

    // Eixo Y
    canvas.drawLine(
      Offset(data.chartLeft, data.chartTop),
      Offset(data.chartLeft, data.chartBottom),
      axisPaint,
    );

    // -------------------------------------------------
    // 3. LABELS EIXO Y (max / 6)
    // -------------------------------------------------
    for (int i = 0; i < data.gridValues.length; i++) {
      final value = data.gridValues[i];
      final y = data.gridY[i];

      final tp = TextPainter(
        text: TextSpan(
          text: formatVolumeBR(value),
          style: baseTheme.labelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(data.chartLeft - tp.width - 6, y - tp.height / 2),
      );
    }

    // -------------------------------------------------
    // 4. LABELS EIXO X
    // -------------------------------------------------
    for (int i = 0; i < data.xLabels.length; i++) {
      final x = data.labelX[i];
      final text = data.xLabels[i];

      final tp = TextPainter(
        text: TextSpan(text: text, style: baseTheme.labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(x - tp.width / 2, data.chartBottom + 4));
    }

    // -------------------------------------------------
    // 5. DESENHAR MONTANHA (fill + stroke)
    // -------------------------------------------------
    if (data.topPoints.isNotEmpty) {
      canvas.drawPath(data.fillPath, fillPaint);
      canvas.drawPath(data.strokePath, strokePaint);
    }

    // -------------------------------------------------
    // 6. HOVER
    // -------------------------------------------------
    if (hoveredPosition != null && hoveredIndex != null) {
      final i = hoveredIndex!;
      if (i >= 0 && i < data.topPoints.length) {
        final point = data.topPoints[i];

        // Linha vertical
        canvas.drawLine(
          Offset(point.dx, data.chartTop),
          Offset(point.dx, data.chartBottom),
          hoverLinePaint,
        );

        // Ponto no topo da montanha
        canvas.drawCircle(point, baseTheme.hoverPointRadius, hoverPointPaint);

        // Tooltip com volume
        _drawTooltip(canvas, point, data.volumes[i]);

        // Data abaixo do eixo X
        if (!data.labelIndexes.contains(i)) {
          final hoverDate = data.fullXLabels[i];

          final tp = TextPainter(
            text: TextSpan(text: hoverDate, style: baseTheme.labelStyle),
            textDirection: TextDirection.ltr,
          )..layout();

          // Detectar sobreposição com labels fixos
          bool hasOverlap = false;
          const overlapThreshold = 50.0;

          for (final fixedX in data.labelX) {
            if ((point.dx - fixedX).abs() < overlapThreshold) {
              hasOverlap = true;
              break;
            }
          }

          // Ajustar posição igual ao gráfico de preço
          final yPosition = hasOverlap
              ? data.chartBottom +
                    20 // deslocado para baixo
              : data.chartBottom + 4; // na mesma linha das datas fixas

          tp.paint(canvas, Offset(point.dx - tp.width / 2, yPosition));
        }
      }
    }
  }

  void _drawTooltip(Canvas canvas, Offset point, double volume) {
    final text = formatVolumeBR(volume);

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: baseTheme.tooltipStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = 6.0;
    final rectWidth = textPainter.width + padding * 2;
    final rectHeight = textPainter.height + padding * 2;

    final tooltipRect = Rect.fromLTWH(
      point.dx - rectWidth / 2,
      point.dy - rectHeight - 12,
      rectWidth,
      rectHeight,
    );

    final rrect = RRect.fromRectAndRadius(
      tooltipRect,
      const Radius.circular(6),
    );

    final bgPaint = Paint()..color = Colors.black.withOpacity(0.80);

    canvas.drawRRect(rrect, bgPaint);

    textPainter.paint(
      canvas,
      Offset(tooltipRect.left + padding, tooltipRect.top + padding),
    );
  }

  @override
  bool shouldRepaint(CanvasMountainPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.hoveredPosition != hoveredPosition;
  }

  String formatVolumeBR(double v) {
    if (v >= 1e12) return "${(v / 1e12).toStringAsFixed(1)} tri";
    if (v >= 1e9) return "${(v / 1e9).toStringAsFixed(1)} bi";
    if (v >= 1e6) return "${(v / 1e6).toStringAsFixed(1)} mi";
    if (v >= 1e3) return "${(v / 1e3).toStringAsFixed(1)} mil";
    return v.toStringAsFixed(0);
  }
}
