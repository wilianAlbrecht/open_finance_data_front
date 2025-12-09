import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import '../components/indicator_compact_item.dart';

// Helpers corretos
String fmt(num? v) => Format.number(v);
String fmtPct(num? v) => Format.percent(v);
String fmtMoney(num? v) => Format.money(v);
String fmtCompact(num? v) => Format.compact(v);
String fmtInt(num? v) => Format.integer(v);
String fmtDate(num? v) => Format.date(v);

class ValuationCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;

  const ValuationCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final mainItems = [
      IndicatorCompactItem(label: "P/E", value: fmt(data.priceToEarnings)),
      IndicatorCompactItem(label: "P/B", value: fmt(data.priceToBook)),
      IndicatorCompactItem(
        label: "Earnings Yield",
        value: fmtPct(data.earningsYield), // AGORA CORRETO
      ),
      IndicatorCompactItem(label: "PEG Ratio", value: fmt(data.pegRatio)),
    ];

    final advancedItems = [
      IndicatorCompactItem(
        label: "EV / Revenue",
        value: fmt(data.enterpriseToRevenue),
      ),
      IndicatorCompactItem(
        label: "EV / EBITDA",
        value: fmt(data.enterpriseToEbitda),
      ),
      IndicatorCompactItem(
        label: "Price/Sales",
        value: fmt(data.priceToSales),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Valuation & Rentabilidade",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...mainItems,
            if (expanded) ...advancedItems,
          ],
        ),

        TextButton(
          onPressed: onToggle,
          child: Text(expanded ? "Ver menos" : "Ver mais"),
        ),
      ],
    );
  }
}
