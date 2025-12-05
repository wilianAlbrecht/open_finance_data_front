import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';

import '../indicator_card_base.dart';

class DividendsCards extends StatelessWidget {
  final IndicatorsModel data;

  const DividendsCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CategorySection(
      title: "Dividendos",

      primaryCards: [
        IndicatorCardBase(
          title: "Dividend Yield",
          value: "${((data.dividendYield ?? 0) * 100).toStringAsFixed(2)}%",
        ),
        IndicatorCardBase(
          title: "Dividend TTM",
          value: data.dividendTtm?.toStringAsFixed(2) ?? "--",
        ),
        IndicatorCardBase(
          title: "Último Dividendo",
          value: data.lastDividendValue?.toStringAsFixed(3) ?? "--",
        ),
        IndicatorCardBase(
          title: "Dividend Rate",
          value: data.dividendRate?.toStringAsFixed(2) ?? "--",
        ),
      ],

      secondaryCards: [
        IndicatorCardBase(
          title: "Dividend Yield 5Y",
          value: data.fiveYearAvgDividendYield?.toStringAsFixed(2) ?? "--",
        ),
        IndicatorCardBase(
          title: "Dividend Yield TTM",
          value: "${((data.dividendYieldTtm ?? 0) * 100).toStringAsFixed(2)}%",
        ),
        IndicatorCardBase(
          title: "Ex-Dividend Date",
          value: data.exDividendDate?.toStringAsFixed(0) ?? "--",
        ),
        IndicatorCardBase(
          title: "Last Dividend Date",
          value: data.lastDividendDate?.toStringAsFixed(0) ?? "--",
        ),
      ],
    );
  }
}
