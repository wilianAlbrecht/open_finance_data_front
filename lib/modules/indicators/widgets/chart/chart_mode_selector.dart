import 'package:flutter/material.dart';

class ChartModeSelector extends StatelessWidget {
  final ChartMode selected;
  final ValueChanged<ChartMode> onChanged;

  const ChartModeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SegmentButton(
          label: "Preço",
          active: selected == ChartMode.price,
          onTap: () => onChanged(ChartMode.price),
        ),
        const SizedBox(width: 8),
        _SegmentButton(
          label: "Volume",
          active: selected == ChartMode.volume,
          onTap: () => onChanged(ChartMode.volume),
        ),
      ],
    );
  }
}

/// ENUM interno ao selector (boa prática)
enum ChartMode {
  price,
  volume,
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? primary : Colors.grey.shade600,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: active ? primary : Colors.grey.shade400,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
