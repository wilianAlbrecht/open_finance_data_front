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

class ProjectionsCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;

  const ProjectionsCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final mainItems = [
      IndicatorCompactItem(
        label: "Target Mean Price",
        value: fmt(data.targetMeanPrice),
      ),
      IndicatorCompactItem(
        label: "Target High Price",
        value: fmt(data.targetHighPrice),
      ),
      IndicatorCompactItem(
        label: "Target Low Price",
        value: fmt(data.targetLowPrice),
      ),
      IndicatorCompactItem(
        label: "Recommendation Mean",
        value: fmt(data.recommendationMean),
      ),
    ];

    final advancedItems = [
      IndicatorCompactItem(
        label: "Analyst Opinions",
        value: fmtInt(data.numberOfAnalystOpinions),
      ),
      IndicatorCompactItem(
        label: "Target Median Price",
        value: fmt(data.targetMedianPrice),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Projeções & Analistas",
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
