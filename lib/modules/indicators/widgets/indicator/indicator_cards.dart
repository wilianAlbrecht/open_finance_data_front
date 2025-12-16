import 'package:flutter/material.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';

// Cards por categoria
import 'cards/price_market_cards.dart';
import 'cards/dividends_cards.dart';
import 'cards/valuation_cards.dart';
import 'cards/financial_health_cards.dart';
import 'cards/projections_cards.dart';

class IndicatorCards extends StatefulWidget {
  final IndicatorsModel data;
  final int columns;

  const IndicatorCards({super.key, required this.data, required this.columns});

  @override
  State<IndicatorCards> createState() => _IndicatorCardsState();
}

class _IndicatorCardsState extends State<IndicatorCards> {
  // 🔽 controle de expansão por seção
  bool priceExpanded = false;
  bool dividendsExpanded = false;
  bool valuationExpanded = false;
  bool financialExpanded = false;
  bool projectionsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================
        // PREÇO & MERCADO
        // ==========================
        PriceMarketCards(
          data: widget.data,
          columns: widget.columns,
          expanded: priceExpanded,
          onToggle: () {
            setState(() => priceExpanded = !priceExpanded);
          },
        ),

        const SizedBox(height: 32),

        // ==========================
        // DIVIDENDOS
        // ==========================
        DividendsCards(
          data: widget.data,
          columns: widget.columns,
          expanded: dividendsExpanded,
          onToggle: () {
            setState(() => dividendsExpanded = !dividendsExpanded);
          },
        ),

        const SizedBox(height: 32),

        // ==========================
        // VALUATION & RENTABILIDADE
        // ==========================
        ValuationCards(
          data: widget.data,
          columns: widget.columns,
          expanded: valuationExpanded,
          onToggle: () {
            setState(() => valuationExpanded = !valuationExpanded);
          },
        ),

        const SizedBox(height: 32),

        // ==========================
        // SAÚDE FINANCEIRA
        // ==========================
        FinancialHealthCards(
          data: widget.data,
          columns: widget.columns,
          expanded: financialExpanded,
          onToggle: () {
            setState(() => financialExpanded = !financialExpanded);
          },
        ),

        const SizedBox(height: 32),

        // ==========================
        // PROJEÇÕES & ANALISTAS
        // ==========================
        ProjectionsCards(
          data: widget.data,
          columns: widget.columns,
          expanded: projectionsExpanded,
          onToggle: () {
            setState(() => projectionsExpanded = !projectionsExpanded);
          },
        ),
      ],
    );
  }
}
