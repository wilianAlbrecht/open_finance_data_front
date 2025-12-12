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
    final pkg = Theme.of(context).extension<AppThemePackage>()!;
    final text = pkg.text;

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
        // ========================
        // TÍTULO DA SEÇÃO
        // ========================
        Text(
          "Projeções & Analistas",
          style: text.sectionTitle,
        ),

        const SizedBox(height: 8),

        // ========================
        // ITENS PRINCIPAIS / AVANÇADOS
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
        // BOTÃO EXPANDIR
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
