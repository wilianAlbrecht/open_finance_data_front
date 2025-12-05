import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
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
          value: Format.percent(data.dividendYield),
        ),
        IndicatorCardBase(
          title: "Dividend TTM",
          value: Format.money(data.dividendTtm),
        ),
        IndicatorCardBase(
          title: "Último Dividendo",
          value: Format.money(data.lastDividendValue),
        ),
        IndicatorCardBase(
          title: "Dividend Rate",
          value: Format.money(data.dividendRate),
        ),
      ],

      secondaryCards: [
        IndicatorCardBase(
          title: "Dividend Yield 5Y",
          value: Format.percent(data.fiveYearAvgDividendYield),
        ),
        IndicatorCardBase(
          title: "Dividend Yield TTM",
          value: Format.percent(data.dividendYieldTtm),
        ),
        IndicatorCardBase(
          title: "Ex-Dividend Date",
          value: Format.date(data.exDividendDate),
        ),
        IndicatorCardBase(
          title: "Última Data Dividendo",
          value: Format.date(data.lastDividendDate),
        ),
      ],
    );
  }
}
