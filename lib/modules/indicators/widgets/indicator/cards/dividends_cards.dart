import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import '../indicator_section.dart';
import '../models/indicator_item_data.dart';

class DividendsCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;
  final int columns;

  const DividendsCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle, 
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final main = [
      IndicatorItemData(label: "Dividend Yield", value: Format.percent(data.dividendYield), highlight: true),
      IndicatorItemData(label: "Dividend Yield TTM", value: Format.percent(data.dividendYieldTtm)),
      IndicatorItemData(label: "Dividend TTM", value: Format.money(data.dividendTtm)),
      IndicatorItemData(label: "Último Dividendo", value: Format.money(data.lastDividendValue)),
      IndicatorItemData(label: "5Y Avg Yield", value: Format.percent(data.fiveYearAvgDividendYield)),
      IndicatorItemData(label: "Ex-Dividend Date", value: Format.date(data.exDividendDate)),
      IndicatorItemData(label: "Last Dividend Date", value: Format.date(data.lastDividendDate)),
    ];

    return IndicatorSection(
      title: "Dividendos",
      items: [...main],
      expanded: expanded,
      onToggle: onToggle,
      columns: columns,
    );
  }
}
