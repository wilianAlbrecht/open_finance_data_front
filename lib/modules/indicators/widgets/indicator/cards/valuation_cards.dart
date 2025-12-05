import 'package:flutter/material.dart';
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
        IndicatorCardBase(title: "P/L (Price/Earnings)", value: data.priceToEarnings?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Earnings Yield", value: "${((data.earningsYield ?? 0) * 100).toStringAsFixed(2)}%"),
        IndicatorCardBase(title: "P/B (Price/Book)", value: data.priceToBook?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Book Value", value: data.bookValue?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Enterprise Value", value: data.enterpriseValue?.toStringAsFixed(0) ?? "--"),
      ],

      secondaryCards: [
        IndicatorCardBase(title: "EV/Receita", value: data.enterpriseToRevenue?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "EV/EBITDA", value: data.enterpriseToEbitda?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Margem Líquida", value: "${((data.profitMargins ?? 0) * 100).toStringAsFixed(2)}%"),
        IndicatorCardBase(title: "ROA", value: "${((data.returnOnAssets ?? 0) * 100).toStringAsFixed(2)}%"),
        IndicatorCardBase(title: "ROE", value: "${((data.returnOnEquity ?? 0) * 100).toStringAsFixed(2)}%"),
        IndicatorCardBase(title: "PEG Ratio", value: data.pegRatio?.toStringAsFixed(2) ?? "--"),
      ],
    );
  }
}
