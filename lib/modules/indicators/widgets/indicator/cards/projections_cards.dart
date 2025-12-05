import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';

import '../indicator_card_base.dart';

class ProjectionsCards extends StatelessWidget {
  final IndicatorsModel data;

  const ProjectionsCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CategorySection(
      title: "Projeções & Analistas",

      primaryCards: [
        IndicatorCardBase(title: "Target High", value: data.targetHighPrice?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Target Low", value: data.targetLowPrice?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Preço Alvo Médio", value: data.targetMeanPrice?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Preço Alvo Mediano", value: data.targetMedianPrice?.toStringAsFixed(2) ?? "--"),
      ],

      secondaryCards: [
        IndicatorCardBase(title: "Recomendação Média", value: data.recommendationMean?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Nº de Analistas", value: data.numberOfAnalystOpinions?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Crescimento Receita", value: "${((data.revenueGrowth ?? 0) * 100).toStringAsFixed(2)}%"),
        IndicatorCardBase(title: "Crescimento Lucro", value: "${((data.earningsGrowth ?? 0) * 100).toStringAsFixed(2)}%"),
      ],
    );
  }
}

