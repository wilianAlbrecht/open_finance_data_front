import 'dart:ui';

class TooltipEntry {
  final String label;     // "Open", "High", "Low", "Close"
  final Color color;      // cor da linha
  final double value;     // valor numérico

  TooltipEntry({
    required this.label,
    required this.color,
    required this.value,
  });
}