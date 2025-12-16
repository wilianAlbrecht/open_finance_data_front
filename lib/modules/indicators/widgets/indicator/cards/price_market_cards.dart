import 'package:flutter/material.dart';
import 'package:open_finance_data_front/core/utils/formatters.dart';
import 'package:open_finance_data_front/data/models/indicators_model.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/indicator_section.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/indicator/models/indicator_item_data.dart';

class PriceMarketCards extends StatelessWidget {
  final IndicatorsModel data;
  final bool expanded;
  final VoidCallback onToggle;
  final int columns;

  const PriceMarketCards({
    super.key,
    required this.data,
    required this.expanded,
    required this.onToggle,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final main = [
      IndicatorItemData(
        label: "Preço Atual",
        value: Format.money(data.currentPrice),
        highlight: true,
      ),
      IndicatorItemData(
        label: "Previous Close",
        value: Format.money(data.previousClose),
      ),
      IndicatorItemData(
        label: "52w High",
        value: Format.money(data.fiftyTwoWeekHigh),
      ),
      IndicatorItemData(
        label: "52w Low",
        value: Format.money(data.fiftyTwoWeekLow),
      ),
      IndicatorItemData(label: "Volume", value: Format.compact(data.volume)),
      IndicatorItemData(
        label: "Avg Volume",
        value: Format.compact(data.averageVolume),
      ),
      IndicatorItemData(
        label: "Market Cap",
        value: Format.compact(data.marketCap),
      ),
      IndicatorItemData(label: "Beta", value: Format.number(data.beta)),
      IndicatorItemData(
        label: "Price / Sales",
        value: Format.number(data.priceToSales),
      ),
      IndicatorItemData(
        label: "Enterprise Value",
        value: Format.compact(data.enterpriseValue),
      ),
      IndicatorItemData(
        label: "EV / Revenue",
        value: Format.number(data.enterpriseToRevenue),
      ),
    ];

    return IndicatorSection(
      title: "Preço & Mercado",
      items: [...main],
      expanded: expanded,
      onToggle: onToggle,
      columns: columns,
    );
  }
}
