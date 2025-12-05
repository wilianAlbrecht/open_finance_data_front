import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
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
        IndicatorCardBase(
          title: "Dívida Total",
          value: Format.compact(data.totalDebt),
        ),
        IndicatorCardBase(
          title: "Dívida / Patrimônio",
          value: Format.number(data.debtToEquity),
        ),
        IndicatorCardBase(
          title: "Caixa Total",
          value: Format.compact(data.totalCash),
        ),
        IndicatorCardBase(
          title: "Caixa por Ação",
          value: Format.money(data.totalCashPerShare),
        ),
      ],

      secondaryCards: [
        IndicatorCardBase(
          title: "Fluxo de Caixa Operacional",
          value: Format.compact(data.operatingCashflow),
        ),
        IndicatorCardBase(
          title: "Fluxo de Caixa Livre",
          value: Format.compact(data.freeCashflow),
        ),
        IndicatorCardBase(
          title: "Lucro Bruto",
          value: Format.compact(data.grossProfits),
        ),
        IndicatorCardBase(
          title: "Receita Total",
          value: Format.compact(data.totalRevenue),
        ),
      ],
    );
  }
}
