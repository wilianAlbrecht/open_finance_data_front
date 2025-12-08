import 'package:flutter/material.dart';
import '../../../data/models/indicators_model.dart';
import '../../../data/services/indicators_service.dart';

class FinancialIndicatorsController extends ChangeNotifier {
  final IndicatorsService service = IndicatorsService();

  bool isLoading = false;
  String? errorMessage;
  String? currentSymbol;

  IndicatorsModel? data;

  Future<void> search(String symbol) async {
    if (symbol.isEmpty) return;

    isLoading = true;
    errorMessage = null;
    currentSymbol = symbol;
    notifyListeners();

    try {
      data = await service.getIndicators(symbol);
    } catch (e) {
      errorMessage = 'Erro ao carregar indicadores financeiros';
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool get hasData => data != null;
}
