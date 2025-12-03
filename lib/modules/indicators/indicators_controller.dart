import 'package:flutter/material.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price_range_filter_bar.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/history_data.dart';
import '../../data/services/openfinance_api.dart';

import './widgets/chart/price_chart_static_builder.dart';
import './widgets/chart/price_chart_series_builder.dart';

class IndicatorsController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? currentSymbol;

  Map<String, dynamic>? fundamentals;
  Map<String, dynamic>? history;

  // Dados do gráfico
  List<double> open = [];
  List<double> high = [];
  List<double> low = [];
  List<double> close = [];
  List<double> volume = [];
  List<int> timestamp = [];

  // Filtro de período
  PriceRange currentRange = PriceRange.oneYear;

  bool showOpen = false;
  bool showHigh = false;
  bool showLow = false;
  bool showClose = true;

  LineChartData? cachedChart;

  Future<void> search(BuildContext context, String symbol) async {
    if (symbol.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final api = context.read<OpenFinanceApi>();

    try {
      currentSymbol = symbol;

      fundamentals = await api.getFundamentals(symbol);
      history = await api.getHistory(symbol);

      if (history == null) {
        errorMessage = "Erro ao buscar histórico";
        isLoading = false;
        notifyListeners();
        return;
      }

      final data = HistoryData.fromJson(history!);

      open = roundList(data.open);
      high = roundList(data.high);
      low = roundList(data.low);
      close = roundList(data.close);
      volume = roundList(data.volume);
      timestamp = data.timestamp;

      // Gera chart estático somente 1 vez
      cachedChart = PriceChartStaticBuilder(
        open: open,
        high: high,
        low: low,
        close: close,
        timestamp: timestamp,
      ).build(context);

      debugPrint("✔ Histórico carregado e gráfico gerado para $symbol");

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Erro ao buscar dados para $symbol";
      isLoading = false;
      notifyListeners();
    }
  }

  /// Build dinâmico das séries (recebe o contexto atual)
  List<LineChartBarData> buildSeries(BuildContext context) {
    if (cachedChart == null) return [];

    return PriceChartSeriesBuilder(
      open: open,
      high: high,
      low: low,
      close: close,
    ).build(
      context,
      showOpen: showOpen,
      showHigh: showHigh,
      showLow: showLow,
      showClose: showClose,
    );
  }

  /// Toggles para atualizar as séries
  void toggleOpen() {
    showOpen = !showOpen;
    notifyListeners();
  }

  void toggleHigh() {
    showHigh = !showHigh;
    notifyListeners();
  }

  void toggleLow() {
    showLow = !showLow;
    notifyListeners();
  }

  void toggleClose() {
    showClose = !showClose;
    notifyListeners();
  }

  void setRange(BuildContext context, PriceRange range) {
    if (currentRange == range) return;

    currentRange = range;

    if (currentSymbol != null && currentSymbol!.isNotEmpty) {
      loadHistoryFiltered(context);
    }

    notifyListeners();
  }

  Future<void> loadHistoryFiltered(BuildContext context) async {
    if (currentSymbol == null || currentSymbol!.isEmpty) return;

    try {
      isLoading = true;
      notifyListeners();

      final api = context.read<OpenFinanceApi>();
      final symbol = currentSymbol!;
      final range = currentRange.apiRange;
      final interval = currentRange.apiInterval;

      // usa a mesma API, só adicionamos parâmetros
      history = await api.getHistory(symbol, range: range, interval: interval);

      if (history == null) {
        errorMessage = "Erro ao filtrar histórico";
        isLoading = false;
        notifyListeners();
        return;
      }

      final data = HistoryData.fromJson(history!);

      open = roundList(data.open);
      high = roundList(data.high);
      low = roundList(data.low);
      close = roundList(data.close);
      volume = roundList(data.volume);
      timestamp = data.timestamp;

      cachedChart = PriceChartStaticBuilder(
        open: open,
        high: high,
        low: low,
        close: close,
        timestamp: timestamp,
      ).build(context);
    } catch (e) {
      errorMessage = "Erro ao aplicar filtro";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Helpers
  double round2(double value) => double.parse(value.toStringAsFixed(2));

  List<double> roundList(List<double> values) {
    return values.map((v) => round2(v)).toList();
  }
}
