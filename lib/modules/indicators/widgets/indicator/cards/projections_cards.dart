import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_section.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/models/indicator_item_data.dart';

class ProjectionsCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;
  final int columns;

  const ProjectionsCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final main = [
      IndicatorItemData(
        label: "Target Mean Price",
        value: Format.money(data.targetMeanPrice),
        highlight: true,
      ),
      IndicatorItemData(
        label: "Target High Price",
        value: Format.money(data.targetHighPrice),
      ),
      IndicatorItemData(
        label: "Target Low Price",
        value: Format.money(data.targetLowPrice),
      ),
      IndicatorItemData(
        label: "Recommendation Mean",
        value: Format.number(data.recommendationMean),
      ),
      IndicatorItemData(
        label: "Analyst Opinions",
        value: Format.integer(data.numberOfAnalystOpinions),
      ),
      IndicatorItemData(
        label: "Target Median Price",
        value: Format.money(data.targetMedianPrice),
      ),
    ];

    return IndicatorSection(
      title: "Projeções & Analistas",
      items: [...main],
      expanded: expanded,
      onToggle: onToggle,
      columns: columns,
    );
  }
}
