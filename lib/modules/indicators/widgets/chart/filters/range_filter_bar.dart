import 'package:flutter/material.dart';
import '../../../../../core/theme/themes/extensions/app_chip_theme.dart';

enum PriceRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  twoYears,
  fiveYears,
  max,
}

extension PriceRangeLabel on PriceRange {
  String get label {
    switch (this) {
      case PriceRange.oneMonth:
        return "1M";
      case PriceRange.threeMonths:
        return "3M";
      case PriceRange.sixMonths:
        return "6M";
      case PriceRange.oneYear:
        return "1A";
      case PriceRange.twoYears:
        return "2A";
      case PriceRange.fiveYears:
        return "5A";
      case PriceRange.max:
        return "Máx";
    }
  }
}

extension PriceRangeApi on PriceRange {
  String get apiRange {
    switch (this) {
      case PriceRange.oneMonth:
        return "1mo";
      case PriceRange.threeMonths:
        return "3mo";
      case PriceRange.sixMonths:
        return "6mo";
      case PriceRange.oneYear:
        return "1y";
      case PriceRange.twoYears:
        return "2y";
      case PriceRange.fiveYears:
        return "5y";
      case PriceRange.max:
        return "max";
    }
  }

  String get apiInterval {
    switch (this) {
      case PriceRange.oneMonth:
        return "1d";
      case PriceRange.threeMonths:
        return "1d";
      case PriceRange.sixMonths:
        return "1wk";
      case PriceRange.oneYear:
        return "1wk";
      case PriceRange.twoYears:
        return "1mo";
      case PriceRange.fiveYears:
        return "1mo";
      case PriceRange.max:
        return "1mo";
    }
  }
}

class RangeFilterBar extends StatelessWidget {
  final PriceRange selected;
  final ValueChanged<PriceRange> onSelected;

  const RangeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppChipTheme>()!;

    return SizedBox(
      height: 42,
      child: Row(
        children: PriceRange.values.map((range) {
          final isSelected = range == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(range),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? theme.selectedBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.borderColor,
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Text(
                  range.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: theme.labelColor,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
