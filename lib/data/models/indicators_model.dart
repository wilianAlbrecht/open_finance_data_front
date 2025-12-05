class IndicatorsModel {
  
  final String symbol;
  final double currentPrice;
  final double? exDividendDate;
  final double? fiveYearAvgDividendYield;
  final double? dividendForward;
  final double? lastDividendValue;
  final double? dividendRate;
  final double? trailingAnnualDividendYield;
  final double? dividendYield;
  final double? lastDividendDate;
  final double? trailingEps;
  final double? forwardEps;
  final double? priceToBook;
  final double? bookValue;
  final double? enterpriseValue;
  final double? enterpriseToRevenue;
  final double? enterpriseToEbitda;
  final double? profitMargins;
  final double? marketCap;
  final double? returnOnAssets;
  final double? returnOnEquity;
  final double? totalDebt;
  final double? debtToEquity;
  final double? sharesOutstanding;
  final double? revenueGrowth;
  final double? earningsGrowth;
  final double? grossMargins;
  final double? operatingMargins;
  final double? ebitdaMargins;
  final double? grossProfits;
  final double? operatingCashflow;
  final double? freeCashflow;
  final double? totalCash;
  final double? totalCashPerShare;
  final double? totalRevenue;
  final double? revenuePerShare;
  final double? targetHighPrice;
  final double? targetLowPrice;
  final double? targetMeanPrice;
  final double? targetMedianPrice;
  final double? recommendationMean;
  final double? numberOfAnalystOpinions;
  final double? previousClose;
  final double? fiftyTwoWeekHigh;
  final double? fiftyTwoWeekLow;
  final double? beta;
  final double? averageVolume;
  final double? volume;
  final double? earningsYield;
  final double? priceToEarnings;
  final double? priceToSales;
  final double? cashPerShare;
  final double? operatingCashflowPerShare;
  final double? freeCashFlowYield;
  final double? pegRatio;
  final double? dividendTtm;
  final double? dividendYieldTtm;

  IndicatorsModel({
    required this.symbol,
    required this.currentPrice,
    this.exDividendDate,
    this.fiveYearAvgDividendYield,
    this.dividendForward,
    this.lastDividendValue,
    this.dividendRate,
    this.trailingAnnualDividendYield,
    this.dividendYield,
    this.lastDividendDate,
    this.trailingEps,
    this.forwardEps,
    this.priceToBook,
    this.bookValue,
    this.enterpriseValue,
    this.enterpriseToRevenue,
    this.enterpriseToEbitda,
    this.profitMargins,
    this.marketCap,
    this.returnOnAssets,
    this.returnOnEquity,
    this.totalDebt,
    this.debtToEquity,
    this.sharesOutstanding,
    this.revenueGrowth,
    this.earningsGrowth,
    this.grossMargins,
    this.operatingMargins,
    this.ebitdaMargins,
    this.grossProfits,
    this.operatingCashflow,
    this.freeCashflow,
    this.totalCash,
    this.totalCashPerShare,
    this.totalRevenue,
    this.revenuePerShare,
    this.targetHighPrice,
    this.targetLowPrice,
    this.targetMeanPrice,
    this.targetMedianPrice,
    this.recommendationMean,
    this.numberOfAnalystOpinions,
    this.previousClose,
    this.fiftyTwoWeekHigh,
    this.fiftyTwoWeekLow,
    this.beta,
    this.averageVolume,
    this.volume,
    this.earningsYield,
    this.priceToEarnings,
    this.priceToSales,
    this.cashPerShare,
    this.operatingCashflowPerShare,
    this.freeCashFlowYield,
    this.pegRatio,
    this.dividendTtm,
    this.dividendYieldTtm,
  });

  factory IndicatorsModel.fromJson(Map<String, dynamic> json) {
    double parse(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return IndicatorsModel(
      symbol: json['symbol'],
      currentPrice: parse(json['currentPrice']),
      exDividendDate: parse(json['exDividendDate']),
      fiveYearAvgDividendYield: parse(json['fiveYearAvgDividendYield']),
      dividendForward: parse(json['dividendForward']),
      lastDividendValue: parse(json['lastDividendValue']),
      dividendRate: parse(json['dividendRate']),
      trailingAnnualDividendYield: parse(json['trailingAnnualDividendYield']),
      dividendYield: parse(json['dividendYield']),
      lastDividendDate: parse(json['lastDividendDate']),
      trailingEps: parse(json['trailingEps']),
      forwardEps: parse(json['forwardEps']),
      priceToBook: parse(json['priceToBook']),
      bookValue: parse(json['bookValue']),
      enterpriseValue: parse(json['enterpriseValue']),
      enterpriseToRevenue: parse(json['enterpriseToRevenue']),
      enterpriseToEbitda: parse(json['enterpriseToEbitda']),
      profitMargins: parse(json['profitMargins']),
      marketCap: parse(json['marketCap']),
      returnOnAssets: parse(json['returnOnAssets']),
      returnOnEquity: parse(json['returnOnEquity']),
      totalDebt: parse(json['totalDebt']),
      debtToEquity: parse(json['debtToEquity']),
      sharesOutstanding: parse(json['sharesOutstanding']),
      revenueGrowth: parse(json['revenueGrowth']),
      earningsGrowth: parse(json['earningsGrowth']),
      grossMargins: parse(json['grossMargins']),
      operatingMargins: parse(json['operatingMargins']),
      ebitdaMargins: parse(json['ebitdaMargins']),
      grossProfits: parse(json['grossProfits']),
      operatingCashflow: parse(json['operatingCashflow']),
      freeCashflow: parse(json['freeCashflow']),
      totalCash: parse(json['totalCash']),
      totalCashPerShare: parse(json['totalCashPerShare']),
      totalRevenue: parse(json['totalRevenue']),
      revenuePerShare: parse(json['revenuePerShare']),
      targetHighPrice: parse(json['targetHighPrice']),
      targetLowPrice: parse(json['targetLowPrice']),
      targetMeanPrice: parse(json['targetMeanPrice']),
      targetMedianPrice: parse(json['targetMedianPrice']),
      recommendationMean: parse(json['recommendationMean']),
      numberOfAnalystOpinions: parse(json['numberOfAnalystOpinions']),
      previousClose: parse(json['previousClose']),
      fiftyTwoWeekHigh: parse(json['fiftyTwoWeekHigh']),
      fiftyTwoWeekLow: parse(json['fiftyTwoWeekLow']),
      beta: parse(json['beta']),
      averageVolume: parse(json['averageVolume']),
      volume: parse(json['volume']),
      earningsYield: parse(json['earningsYield']),
      priceToEarnings: parse(json['priceToEarnings']),
      priceToSales: parse(json['priceToSales']),
      cashPerShare: parse(json['cashPerShare']),
      operatingCashflowPerShare: parse(json['operatingCashflowPerShare']),
      freeCashFlowYield: parse(json['freeCashFlowYield']),
      pegRatio: parse(json['pegRatio']),
      dividendTtm: parse(json['dividendTtm']),
      dividendYieldTtm: parse(json['dividendYieldTtm']),
    );
  }
}
