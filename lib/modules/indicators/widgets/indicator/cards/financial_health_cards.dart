import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_theme_package.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import '../components/indicator_compact_item.dart';

// Helpers de formatação
String fmt(num? v) => Format.number(v);
String fmtPct(num? v) => Format.percent(v);
String fmtMoney(num? v) => Format.money(v);
String fmtCompact(num? v) => Format.compact(v);
String fmtInt(num? v) => Format.integer(v);
String fmtDate(num? v) => Format.date(v);

class FinancialHealthCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;

  const FinancialHealthCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

    // ========================
    // ITENS PRINCIPAIS
    // ========================
    final mainItems = [
      IndicatorCompactItem(label: "Total Cash", value: fmtCompact(data.totalCash)),
      IndicatorCompactItem(label: "Total Debt", value: fmtCompact(data.totalDebt)),
      IndicatorCompactItem(label: "Cash Per Share", value: fmt(data.cashPerShare)),
      IndicatorCompactItem(label: "Debt / Equity", value: fmt(data.debtToEquity)),
    ];

    // ========================
    // ITENS AVANÇADOS
    // ========================
    final advancedItems = [
      IndicatorCompactItem(label: "Operating Cashflow", value: fmtCompact(data.operatingCashflow)),
      IndicatorCompactItem(label: "Free Cashflow", value: fmtCompact(data.freeCashflow)),
      IndicatorCompactItem(label: "OCF Per Share", value: fmt(data.operatingCashflowPerShare)),
      IndicatorCompactItem(label: "Free Cashflow Yield", value: fmtPct(data.freeCashFlowYield)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================
        // TÍTULO DA SEÇÃO
        // ========================
        Text(
          "Saúde Financeira",
          style: text.sectionTitle,
        ),

        const SizedBox(height: 8),

        // ========================
        // GRID DE ITENS
        // ========================
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...mainItems,
            if (expanded) ...advancedItems,
          ],
        ),

        // ========================
        // BOTÃO EXPANDIR / REDUZIR
        // ========================
        TextButton(
          onPressed: onToggle,
          child: Text(
            expanded ? "Ver menos" : "Ver mais",
            style: text.showMoreButton,
          ),
        ),
      ],
    );
  }
}
