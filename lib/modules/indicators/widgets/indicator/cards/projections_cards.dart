import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
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
        IndicatorCardBase(
          title: "Preço Alvo Máximo",
          value: Format.money(data.targetHighPrice),
        ),
        IndicatorCardBase(
          title: "Preço Alvo Mínimo",
          value: Format.money(data.targetLowPrice),
        ),
        IndicatorCardBase(
          title: "Preço Alvo Médio",
          value: Format.money(data.targetMeanPrice),
        ),
        IndicatorCardBase(
          title: "Preço Mediano",
          value: Format.money(data.targetMedianPrice),
        ),
      ],

      secondaryCards: [
        IndicatorCardBase(
          title: "Recomendação Média",
          value: Format.number(data.recommendationMean),
        ),
        IndicatorCardBase(
          title: "Nº Analistas",
          value: Format.integer(data.numberOfAnalystOpinions),
        ),
        IndicatorCardBase(
          title: "Crescimento Receita",
          value: Format.percent(data.revenueGrowth),
        ),
        IndicatorCardBase(
          title: "Crescimento Lucro",
          value: Format.percent(data.earningsGrowth),
        ),
      ],
    );
  }
}
