import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';

import 'cards/price_cards.dart';
import 'cards/dividends_cards.dart';
import 'cards/financial_health_cards.dart';
import 'cards/valuation_cards.dart';
import 'cards/projections_cards.dart';

class IndicatorCards extends StatefulWidget {
  final IndicatorsModel data;

  const IndicatorCards({
    super.key,
    required this.data,
  });

  @override
  State<IndicatorCards> createState() => _IndicatorCardsState();
}

class _IndicatorCardsState extends State<IndicatorCards> {
  bool expandPrice = false;
  bool expandDiv = false;
  bool expandVal = false;
  bool expandHealth = false;
  bool expandProj = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        //  PREÇO & MERCADO
        // ============================================================
        PriceCards(
          data: data,
          expanded: expandPrice,
          onToggle: () => setState(() => expandPrice = !expandPrice),
        ),
        const SizedBox(height: 24),

        // ============================================================
        //  DIVIDENDOS
        // ============================================================
        DividendsCards(
          data: data,
          expanded: expandDiv,
          onToggle: () => setState(() => expandDiv = !expandDiv),
        ),
        const SizedBox(height: 24),

        // ============================================================
        //  VALUATION & RENTABILIDADE
        // ============================================================
        ValuationCards(
          data: data,
          expanded: expandVal,
          onToggle: () => setState(() => expandVal = !expandVal),
        ),
        const SizedBox(height: 24),

        // ============================================================
        //  SAÚDE FINANCEIRA
        // ============================================================
        FinancialHealthCards(
          data: data,
          expanded: expandHealth,
          onToggle: () => setState(() => expandHealth = !expandHealth),
        ),
        const SizedBox(height: 24),

        // ============================================================
        //  PROJEÇÕES E ANALISTAS
        // ============================================================
        ProjectionsCards(
          data: data,
          expanded: expandProj,
          onToggle: () => setState(() => expandProj = !expandProj),
        ),
      ],
    );
  }
}
