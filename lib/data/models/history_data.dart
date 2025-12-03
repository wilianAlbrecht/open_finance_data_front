class HistoryData {
  final List<int> timestamp;
  final List<double> open;
  final List<double> high;
  final List<double> low;
  final List<double> close;
  final List<double> volume;

  List<double> ma20 = [];

  HistoryData({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  }) {
    _calculateMA20();
  }

  // ---- Parsing seguro e elegante ----
  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      timestamp: _toIntList(json["timestamp"]),
      open: _toDoubleList(json["open"]),
      high: _toDoubleList(json["high"]),
      low: _toDoubleList(json["low"]),
      close: _toDoubleList(json["close"]),
      volume: _toDoubleList(json["volume"]),
    );
  }

  // ---- Converte List<dynamic> → List<double> ----
  static List<double> _toDoubleList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((e) => (e as num?)?.toDouble() ?? 0).toList();
  }

  // ---- Converte List<dynamic> → List<int> ----
  static List<int> _toIntList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((e) => (e as num).toInt()).toList();
  }

  // ---- MA20 automático ----
  void _calculateMA20() {
    ma20 = [];

    for (int i = 0; i < close.length; i++) {
      if (i < 20) {
        ma20.add(close[i]);
      } else {
        double sum = 0;
        for (int j = i - 19; j <= i; j++) {
          sum += close[j];
        }
        ma20.add(sum / 20);
      }
    }
  }
}
