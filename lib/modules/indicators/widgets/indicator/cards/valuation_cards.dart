import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';
import '../indicator_card_base.dart';

class ValuationCards extends StatelessWidget {
  final IndicatorsModel data;

  const ValuationCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CategorySection(
      title: "Valuation & Rentabilidade",

      primaryCards: [
        IndicatorCardBase(
          title: "P/L",
          value: Format.number(data.priceToEarnings),
        ),
        IndicatorCardBase(
          title: "Earnings Yield",
          value: Format.percent(data.earningsYield),
        ),
        IndicatorCardBase(
          title: "P/B",
          value: Format.number(data.priceToBook),
        ),
        IndicatorCardBase(
          title: "Book Value",
          value: Format.money(data.bookValue),
        ),
        IndicatorCardBase(
          title: "Enterprise Value",
          value: Format.compact(data.enterpriseValue),
        ),
      ],

      secondaryCards: [
        IndicatorCardBase(
          title: "EV / Receita",
          value: Format.number(data.enterpriseToRevenue),
        ),
        IndicatorCardBase(
          title: "EV / EBITDA",
          value: Format.number(data.enterpriseToEbitda),
        ),
        IndicatorCardBase(
          title: "Margem Líquida",
          value: Format.percent(data.profitMargins),
        ),
        IndicatorCardBase(
          title: "ROA",
          value: Format.percent(data.returnOnAssets),
        ),
        IndicatorCardBase(
          title: "ROE",
          value: Format.percent(data.returnOnEquity),
        ),
        IndicatorCardBase(
          title: "PEG Ratio",
          value: Format.number(data.pegRatio),
        ),
      ],
    );
  }
}
