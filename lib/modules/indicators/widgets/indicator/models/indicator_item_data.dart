class IndicatorItemData {
  final String label;
  final String value;
  final String? tooltip;
  final bool highlight;

  const IndicatorItemData({
    required this.label,
    required this.value,
    this.tooltip,
    this.highlight = false,
  });
}
