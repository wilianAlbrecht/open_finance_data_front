import 'package:intl/intl.dart';

class Format {
  static String number(num? v, {int decimals = 2}) {
    if (v == null) return "--";
    return v.toStringAsFixed(decimals);
  }

  static String percent(num? v, {int decimals = 2}) {
    if (v == null) return "--";
    return "${(v * 100).toStringAsFixed(decimals)}%";
  }

  static String money(num? v, {int decimals = 2}) {
    if (v == null) return "--";
    return "R\$ " + v.toStringAsFixed(decimals);
  }

  static String compact(num? v) {
    if (v == null) return "--";
    if (v.abs() >= 1e12) return "${(v / 1e12).toStringAsFixed(2)}T";
    if (v.abs() >= 1e9) return "${(v / 1e9).toStringAsFixed(2)}B";
    if (v.abs() >= 1e6) return "${(v / 1e6).toStringAsFixed(2)}M";
    // if (v.abs() >= 1e3) return "${(v / 1e3).toStringAsFixed(2)}K";
    return v.toStringAsFixed(2);
  }

  static String integer(num? v) {
    if (v == null) return "--";
    return v.toStringAsFixed(0);
  }

  static String date(num? timestamp) {
    if (timestamp == null || timestamp == 0) return "--";

    try {
      // Timestamp do Yahoo = em segundos
      final date = DateTime.fromMillisecondsSinceEpoch(
        (timestamp * 1000).toInt(),
        isUtc: true,
      );

      return DateFormat("dd/MM/yyyy").format(date);
    } catch (_) {
      return "--";
    }
  }
}
