import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/theme/themes/extensions/app_page_layout_theme.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';

import '../indicator_card_base.dart';

class PriceCards extends StatelessWidget {
  final IndicatorsModel data;

  const PriceCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final layout = Theme.of(context).extension<AppPageLayoutTheme>()!;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: layout.maxContentWidth),
        child: CategorySection(
          title: "Preço & Mercado",

          // CARDS PRINCIPAIS
          primaryCards: [
            IndicatorCardBase(title: "Preço Atual", value: data.currentPrice.toStringAsFixed(2)),
            IndicatorCardBase(title: "Fechamento Anterior", value: data.previousClose?.toStringAsFixed(2) ?? "--"),
            IndicatorCardBase(title: "Máx. 52 semanas", value: data.fiftyTwoWeekHigh?.toStringAsFixed(2) ?? "--"),
            IndicatorCardBase(title: "Mín. 52 semanas", value: data.fiftyTwoWeekLow?.toStringAsFixed(2) ?? "--"),
          ],

          // CARDS SECUNDÁRIOS
          secondaryCards: [
            IndicatorCardBase(title: "Beta", value: data.beta?.toStringAsFixed(2) ?? "--"),
            IndicatorCardBase(title: "Market Cap", value: data.marketCap?.toStringAsFixed(0) ?? "--"),
            IndicatorCardBase(title: "Volume Médio", value: data.averageVolume?.toStringAsFixed(0) ?? "--"),
            IndicatorCardBase(title: "Volume Atual", value: data.volume?.toStringAsFixed(0) ?? "--"),
          ],
        ),
      ),
    );
  }
}
