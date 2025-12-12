import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'canvas_mountain_chart_builder.dart';

class CanvasMountainPainter extends CustomPainter {
  final CanvasMountainChartData data;
  final int? hoveredIndex;
  final Offset? hoveredPosition;

  // Agora recebe o tema plano
  final AppThemePackage themePkg;

  CanvasMountainPainter({
    required this.data,
    required this.hoveredIndex,
    required this.hoveredPosition,
    required this.themePkg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final canvasTheme = themePkg.canvas;

    // ================================
    // GRID
    // ================================
    final gridPaint = Paint()
      ..color = canvasTheme.gridColor
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = canvasTheme.axisTextColor.withOpacity(0.8)
      ..strokeWidth = 1.2;

    // ================================
    // MONTANHA — GRADIENTE USANDO CORES DO THEME
    // ================================
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          canvasTheme.volumeTopColor,
          canvasTheme.volumeTopColor.withOpacity(0.35),
          canvasTheme.volumeBottomColor.withOpacity(0.12),
        ],
      ).createShader(
        Rect.fromLTRB(
          data.chartLeft,
          data.chartTop,
          data.chartRight,
          data.chartBottom,
        ),
      );

    final strokePaint = Paint()
      ..color = canvasTheme.volumeTopColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final hoverLinePaint = Paint()
      ..color = canvasTheme.lineColor
      ..strokeWidth = 1.2;

    final hoverPointPaint = Paint()
      ..color = canvasTheme.lineColor
      ..style = PaintingStyle.fill;

    // ================================
    // 1. GRID HORIZONTAL
    // ================================
    for (final y in data.gridY) {
      canvas.drawLine(
        Offset(data.chartLeft, y),
        Offset(data.chartRight, y),
        gridPaint,
      );
    }

    // ================================
    // 2. EIXOS
    // ================================
    // X
    canvas.drawLine(
      Offset(data.chartLeft, data.chartBottom),
      Offset(data.chartRight, data.chartBottom),
      axisPaint,
    );

    // Y
    canvas.drawLine(
      Offset(data.chartLeft, data.chartTop),
      Offset(data.chartLeft, data.chartBottom),
      axisPaint,
    );

    // ================================
    // 3. LABELS EIXO Y
    // ================================
    for (int i = 0; i < data.gridValues.length; i++) {
      final value = data.gridValues[i];
      final y = data.gridY[i];

      final painter = TextPainter(
        text: TextSpan(
          text: formatVolumeBR(value),
          style: TextStyle(
            fontSize: 11,
            color: canvasTheme.axisTextColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(
        canvas,
        Offset(data.chartLeft - painter.width - 6, y - painter.height / 2),
      );
    }

    // ================================
    // 4. LABELS EIXO X
    // ================================
    for (int i = 0; i < data.xLabels.length; i++) {
      final x = data.labelX[i];
      final text = data.xLabels[i];

      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 11,
            color: canvasTheme.axisTextColor,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      painter.paint(canvas, Offset(x - painter.width / 2, data.chartBottom + 4));
    }

    // ================================
    // 5. DESENHAR MONTANHA
    // ================================
    if (data.topPoints.isNotEmpty) {
      canvas.drawPath(data.fillPath, fillPaint);
      canvas.drawPath(data.strokePath, strokePaint);
    }

    // ================================
    // 6. HOVER
    // ================================
    if (hoveredPosition != null && hoveredIndex != null) {
      final i = hoveredIndex!;
      if (i >= 0 && i < data.topPoints.length) {
        final point = data.topPoints[i];

        canvas.drawLine(
          Offset(point.dx, data.chartTop),
          Offset(point.dx, data.chartBottom),
          hoverLinePaint,
        );

        canvas.drawCircle(point, 4, hoverPointPaint);

        _drawTooltip(canvas, point, data.volumes[i], canvasTheme);

        // DATA HOVER
        if (!data.labelIndexes.contains(i)) {
          final hoverDate = data.fullXLabels[i];

          final tp = TextPainter(
            text: TextSpan(
              text: hoverDate,
              style: TextStyle(
                fontSize: 11,
                color: canvasTheme.axisTextColor,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          tp.paint(
            canvas,
            Offset(point.dx - tp.width / 2, data.chartBottom + 20),
          );
        }
      }
    }
  }

  // ===================================================
  // TOOLTIP
  // ===================================================
  void _drawTooltip(Canvas canvas, Offset point, double volume, canvasTheme) {
    final text = formatVolumeBR(volume);

    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = 6.0;

    final rect = Rect.fromLTWH(
      point.dx - painter.width / 2 - padding,
      point.dy - painter.height - 20,
      painter.width + padding * 2,
      painter.height + padding * 2,
    );

    final bg = Paint()..color = Colors.black.withOpacity(0.85);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      bg,
    );

    painter.paint(canvas, Offset(rect.left + padding, rect.top + padding));
  }

  @override
  bool shouldRepaint(CanvasMountainPainter old) =>
      old.data != data ||
      old.hoveredIndex != hoveredIndex ||
      old.hoveredPosition != hoveredPosition;
}

// =======================================================
// Formatador rápido (igual ao seu original)
// =======================================================
String formatVolumeBR(double v) {
  if (v >= 1e12) return "${(v / 1e12).toStringAsFixed(1)} tri";
  if (v >= 1e9) return "${(v / 1e9).toStringAsFixed(1)} bi";
  if (v >= 1e6) return "${(v / 1e6).toStringAsFixed(1)} mi";
  if (v >= 1e3) return "${(v / 1e3).toStringAsFixed(1)} mil";
  return v.toStringAsFixed(0);
}
