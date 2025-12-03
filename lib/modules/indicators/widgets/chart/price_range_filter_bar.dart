import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_chip_theme.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price_range_filter_bar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/themes/extensions/app_chip_theme.dart';

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

class PriceRangeFilterBar extends StatelessWidget {
  final PriceRange selected;
  final ValueChanged<PriceRange> onSelected;

  const PriceRangeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppChipTheme>()!;

    return SizedBox(
      height: 42,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: PriceRange.values.map((range) {
            final isSelected = range == selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: RangeChip(
                label: range.label,
                isSelected: isSelected,
                theme: theme,
                onTap: () => onSelected(range),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class RangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final AppChipTheme theme;
  final VoidCallback onTap;

  const RangeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.borderColor,
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? theme.labelColor : theme.labelColor,
          ),
        ),
      ),
    );
  }
}
