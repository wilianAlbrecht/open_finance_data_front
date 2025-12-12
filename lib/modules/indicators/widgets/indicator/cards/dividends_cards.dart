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

class DividendsCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;

  const DividendsCards({
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
      IndicatorCompactItem(
        label: "Dividend Yield",
        value: fmtPct(data.dividendYield),
      ),
      IndicatorCompactItem(
        label: "Dividend Yield TTM",
        value: fmtPct(data.dividendYieldTtm),
      ),
      IndicatorCompactItem(
        label: "Dividend TTM",
        value: fmt(data.dividendTtm),
      ),
      IndicatorCompactItem(
        label: "Último Dividendo",
        value: fmt(data.lastDividendValue),
      ),
    ];

    // ========================
    // ITENS AVANÇADOS
    // ========================
    final advancedItems = [
      IndicatorCompactItem(
        label: "5Y Avg Yield",
        value: fmtPct(data.fiveYearAvgDividendYield),
      ),
      IndicatorCompactItem(
        label: "Ex-Dividend Date",
        value: fmtDate(data.exDividendDate),
      ),
      IndicatorCompactItem(
        label: "Last Dividend Date",
        value: fmtDate(data.lastDividendDate),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================
        // TÍTULO
        // ========================
        Text(
          "Dividendos",
          style: text.sectionTitle,
        ),

        const SizedBox(height: 8),

        // ========================
        // GRID DE INDICADORES
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
        // BOTÃO EXPANDIR / CONTRAIR
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
