import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import '../components/indicator_compact_item.dart';

// Helpers de formatação (atalhos para sua classe Format)
String fmt(num? v) => Format.number(v);
String fmtPct(num? v) => Format.percent(v);
String fmtMoney(num? v) => Format.money(v);
String fmtCompact(num? v) => Format.compact(v);
String fmtInt(num? v) => Format.integer(v);
String fmtDate(num? v) => Format.date(v);

class PriceCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;

  const PriceCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final mainItems = [
      IndicatorCompactItem(label: "Preço Atual", value: fmt(data.currentPrice)),
      IndicatorCompactItem(label: "Previous Close", value: fmt(data.previousClose),),
      IndicatorCompactItem(label: "52w High", value: fmt(data.fiftyTwoWeekHigh),),
      IndicatorCompactItem(label: "52w Low", value: fmt(data.fiftyTwoWeekLow)),
    ];

    final advancedItems = [
      IndicatorCompactItem(label: "Volume", value: fmtCompact(data.volume)),
      IndicatorCompactItem(label: "Avg Volume", value: fmtCompact(data.averageVolume),),
      IndicatorCompactItem(label: "Market Cap", value: fmtCompact(data.marketCap),),
      IndicatorCompactItem(label: "Beta", value: fmt(data.beta)),
      IndicatorCompactItem(label: "Price/Sales", value: fmt(data.priceToSales)),
      IndicatorCompactItem(label: "Enterprise Value", value: fmtCompact(data.enterpriseValue),),
      IndicatorCompactItem(label: "EV / Revenue",value: fmt(data.enterpriseToRevenue),),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Preço & Mercado", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [...mainItems, if (expanded) ...advancedItems],
        ),

        TextButton(
          onPressed: onToggle,
          child: Text(expanded ? "Ver menos" : "Ver mais"),
        ),
      ],
    );
  }
}
