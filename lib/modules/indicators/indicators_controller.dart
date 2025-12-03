import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/history_data.dart';
import '../../data/services/openfinance_api.dart';

class IndicatorsController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? currentSymbol;

  Map<String, dynamic>? fundamentals;
  Map<String, dynamic>? history;

  //dados do histórico para o gráfico
  List<double> open = [];
  List<double> high = [];
  List<double> low = [];
  List<double> close = [];
  List<double> volume = [];
  List<int> timestamp = [];

  bool showOpen = false;
  bool showHigh = false;
  bool showLow = false;
  bool showClose = true; // ativo por padrão

  Future<void> search(BuildContext context, String symbol) async {
    if (symbol.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final api = context.read<OpenFinanceApi>();

    try {
      currentSymbol = symbol;

      // CHAMADAS REAIS:
      fundamentals = await api.getFundamentals(symbol);
      history = await api.getHistory(symbol);

      late final HistoryData data;

      if (history == null) {
        errorMessage = "Erro ao buscar histórico";
        isLoading = false;
        notifyListeners();
        return;
      } else {
        data = HistoryData.fromJson(history!);
      }

      open = roundList(data.open);
      close = roundList(data.close);
      high = roundList(data.high);
      low = roundList(data.low);
      volume = roundList(data.volume);
      timestamp = data.timestamp;

      debugPrint("✔ Dados carregados para $symbol");

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = "Erro ao buscar dados para $symbol";
      isLoading = false;
      notifyListeners();
    }
  }

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

  double round2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  List<double> roundList(List<double> values) {
    return values.map((v) => round2(v)).toList();
  }
}
