import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';

import '../indicator_card_base.dart';

class PriceCards extends StatelessWidget {
  final IndicatorsModel data;

  const PriceCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CategorySection(
      title: "Preço & Mercado",

      primaryCards: [
        IndicatorCardBase(title: "Preço Atual", value: Format.money(data.currentPrice)),
        IndicatorCardBase(title: "Fechamento Anterior", value: Format.money(data.previousClose)),
        IndicatorCardBase(title: "Máx. 52 semanas", value: Format.money(data.fiftyTwoWeekHigh)),
        IndicatorCardBase(title: "Mín. 52 semanas", value: Format.money(data.fiftyTwoWeekLow)),
      ],

      secondaryCards: [
        IndicatorCardBase(title: "Beta", value: Format.number(data.beta)),
        IndicatorCardBase(title: "Market Cap", value: Format.compact(data.marketCap)),
        IndicatorCardBase(title: "Volume Médio", value: Format.compact(data.averageVolume)),
        IndicatorCardBase(title: "Volume Atual", value: Format.compact(data.volume)),
      ],
    );
  }
}
