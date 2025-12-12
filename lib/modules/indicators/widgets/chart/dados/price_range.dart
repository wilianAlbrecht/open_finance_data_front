
enum PriceRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  twoYears,
  fiveYears,
  max,
}

extension PriceRangeLabel on PriceRange {
  String get label {
    switch (this) {
      case PriceRange.oneMonth:
        return "1M";
      case PriceRange.threeMonths:
        return "3M";
      case PriceRange.sixMonths:
        return "6M";
      case PriceRange.oneYear:
        return "1A";
      case PriceRange.twoYears:
        return "2A";
      case PriceRange.fiveYears:
        return "5A";
      case PriceRange.max:
        return "Máx";
    }
  }
}

extension PriceRangeApi on PriceRange {
  String get apiRange {
    switch (this) {
      case PriceRange.oneMonth:
        return "1mo";
      case PriceRange.threeMonths:
        return "3mo";
      case PriceRange.sixMonths:
        return "6mo";
      case PriceRange.oneYear:
        return "1y";
      case PriceRange.twoYears:
        return "2y";
      case PriceRange.fiveYears:
        return "5y";
      case PriceRange.max:
        return "max";
    }
  }

  String get apiInterval {
    switch (this) {
      case PriceRange.oneMonth:
        return "1d";
      case PriceRange.threeMonths:
        return "1d";
      case PriceRange.sixMonths:
        return "1wk";
      case PriceRange.oneYear:
        return "1wk";
      case PriceRange.twoYears:
        return "1mo";
      case PriceRange.fiveYears:
        return "1mo";
      case PriceRange.max:
        return "1mo";
    }
  }
}