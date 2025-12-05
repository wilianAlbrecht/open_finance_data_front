import 'package:dio/dio.dart';

class OpenFinanceApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://93.127.211.242:8081/api",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  // ----------- Histórico (gráfico) -----------
  Future<Map<String, dynamic>> getHistory(
    String symbol, {
    String range = "1mo",
    String interval = "1d",
  }) async {
    final response = await _dio.get(
      "/history/$symbol",
      queryParameters: {
        "range": range,
        "interval": interval,
        "mode": "unified",
      },
    );
    return response.data;
  }

  // ----------- Fundamentais (indicadores) -----------
  Future<Map<String, dynamic>> getFundamentals(String symbol) async {
    final response = await _dio.get(
      "/fundamentals/$symbol",
      queryParameters: {"mode": "unified"},
    );
    return response.data;
  }

  // ----------- Preço (opcional) -----------
  Future<Map<String, dynamic>> getPrice(String symbol) async {
    final response = await _dio.get("/price/$symbol");
    return response.data;
  }
}
