import 'package:flutter/material.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/chart_mode_selector.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/filters/range_filter_bar.dart';
import 'package:open_finance_data_front/modules/indicators/widgets/chart/price/price_chart_builder.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../data/models/history_data.dart';
import '../../../data/services/history_service.dart';

class IndicatorsController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? currentSymbol;

  Map<String, dynamic>? fundamentals;
  Map<String, dynamic>? history;

  ChartMode chartMode = ChartMode.price;

  // Dados do gráfico
  List<double> open = [];
  List<double> high = [];
  List<double> low = [];
  List<double> close = [];
  List<double> volume = [];
  List<int> timestamp = [];

  // Filtro de período
  PriceRange currentRange = PriceRange.oneYear;

  // Filtros OHLC
  bool showOpen = false;
  bool showHigh = false;
  bool showLow = false;
  bool showClose = true;

  // Resultado final do builder
  PriceChartResult? chartResult;

  // ============================================================
  // SEARCH PRINCIPAL
  // ============================================================

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

      // 👉 Novo: usa o builder unificado
      rebuildChart(context);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Erro ao buscar dados para $symbol";
      isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REBUILD DO GRÁFICO
  // ============================================================

  void rebuildChart(BuildContext context) {
    if (timestamp.isEmpty) return;

    final builder = PriceChartBuilder(
      open: open,
      high: high,
      low: low,
      close: close,
      timestamp: timestamp,
      showOpen: showOpen,
      showHigh: showHigh,
      showLow: showLow,
      showClose: showClose,
    );

    chartResult = builder.build(context);
    notifyListeners();
  }

  // ============================================================
  // TOGGLES OHLC
  // ============================================================

  void toggleOpen(BuildContext context) {
    showOpen = !showOpen;
    rebuildChart(context);
  }

  void toggleHigh(BuildContext context) {
    showHigh = !showHigh;
    rebuildChart(context);
  }

  void toggleLow(BuildContext context) {
    showLow = !showLow;
    rebuildChart(context);
  }

  void toggleClose(BuildContext context) {
    showClose = !showClose;
    rebuildChart(context);
  }

  // ============================================================
  // RANGE FILTER
  // ============================================================

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

      // 👉 Rebuild com novos dados
      rebuildChart(context);
    } catch (e) {
      errorMessage = "Erro ao aplicar filtro";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setChartMode(ChartMode mode) {
    if (chartMode == mode) return;

    chartMode = mode;
    notifyListeners();
  }

  // ============================================================
  // HELPERS
  // ============================================================

  double round2(double value) => double.parse(value.toStringAsFixed(2));

  List<double> roundList(List<double> values) =>
      values.map((v) => round2(v)).toList();
}
