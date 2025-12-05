import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/CategorySection.dart';

import '../indicator_card_base.dart';

class FinancialHealthCards extends StatelessWidget {
  final IndicatorsModel data;

  const FinancialHealthCards({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CategorySection(
      title: "Saúde Financeira",

      primaryCards: [
        IndicatorCardBase(title: "Dívida Total", value: data.totalDebt?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Dívida / Patrimônio", value: data.debtToEquity?.toStringAsFixed(2) ?? "--"),
        IndicatorCardBase(title: "Caixa Total", value: data.totalCash?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Caixa por Ação", value: data.totalCashPerShare?.toStringAsFixed(2) ?? "--"),
      ],

      secondaryCards: [
        IndicatorCardBase(title: "Fluxo de Caixa Operacional", value: data.operatingCashflow?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Fluxo de Caixa Livre", value: data.freeCashflow?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Lucro Bruto", value: data.grossProfits?.toStringAsFixed(0) ?? "--"),
        IndicatorCardBase(title: "Receita Total", value: data.totalRevenue?.toStringAsFixed(0) ?? "--"),
      ],
    );
  }
}
