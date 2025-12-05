import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';

export 'cards/dividends_cards.dart';
export 'cards/price_cards.dart';
export 'cards/valuation_cards.dart';
export 'cards/financial_health_cards.dart';
export 'cards/projections_cards.dart';

import 'cards/dividends_cards.dart';
import 'cards/price_cards.dart';
import 'cards/valuation_cards.dart';
import 'cards/financial_health_cards.dart';
import 'cards/projections_cards.dart';

class IndicatorCards extends StatelessWidget {
  final IndicatorsModel data;

  const IndicatorCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PriceCards(data: data),
        DividendsCards(data: data),
        ValuationCards(data: data),
        FinancialHealthCards(data: data),
        ProjectionsCards(data: data),
      ],
    );
  }
}
