import 'package:dio/dio.dart';
import '../models/indicators_model.dart';

class IndicatorsService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://93.127.211.242:8082/api"));

  Future<IndicatorsModel> getIndicators(String symbol) async {
    final response = await _dio.get('/stock/$symbol');
    return IndicatorsModel.fromJson(response.data);
  }

  // Future<IndicatorsModel> getIndicators(String symbol) async {
  //   final response = await _dio.get('/stock/$symbol');

  //   if (response.statusCode != 200) {
  //     throw Exception("Erro ao buscar indicadores financeiros");
  //   }

  //   // Convertendo JSON string → Map → Model
  //   final Map<String, dynamic> jsonMap = response.data;

  //   return IndicatorsModel.fromJson(jsonMap);
  // }
}
