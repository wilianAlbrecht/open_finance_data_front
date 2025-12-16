import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_section.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/models/indicator_item_data.dart';

class FinancialHealthCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;
   final int columns;

  const FinancialHealthCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final main = [
      IndicatorItemData(label: "Total Cash", value: Format.compact(data.totalCash), highlight: true),
      IndicatorItemData(label: "Total Debt", value: Format.compact(data.totalDebt)),
      IndicatorItemData(label: "Cash Per Share", value: Format.number(data.cashPerShare)),
      IndicatorItemData(label: "Debt / Equity", value: Format.number(data.debtToEquity)),
      IndicatorItemData(label: "Operating Cashflow", value: Format.compact(data.operatingCashflow)),
      IndicatorItemData(label: "Free Cashflow", value: Format.compact(data.freeCashflow)),
      IndicatorItemData(label: "OCF Per Share", value: Format.number(data.operatingCashflowPerShare)),
      IndicatorItemData(label: "Free Cashflow Yield", value: Format.percent(data.freeCashFlowYield)),
    ];

    return IndicatorSection(
      title: "Saúde Financeira",
      items: [...main],
      expanded: expanded,
      onToggle: onToggle,
      columns: columns,
    );
  }
}
