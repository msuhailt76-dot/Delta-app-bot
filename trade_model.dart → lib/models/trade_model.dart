class TradeLegResult {
  final String leg;
  final String symbol;
  final String reason;
  final double? entryPremium;
  final double? exitPremium;
  final double? peakPct;
  final double? currentPct;
  final double? pnlUsd;
  final String? closedAt;

  TradeLegResult({
    required this.leg,
    required this.symbol,
    required this.reason,
    required this.entryPremium,
    required this.exitPremium,
    required this.peakPct,
    required this.currentPct,
    required this.pnlUsd,
    required this.closedAt,
  });

  factory TradeLegResult.fromJson(Map<String, dynamic> json) {
    return TradeLegResult(
      leg: json["leg"] ?? "",
      symbol: json["symbol"] ?? "",
      reason: json["reason"] ?? "",
      entryPremium: (json["entry_premium"] as num?)?.toDouble(),
      exitPremium: (json["exit_premium"] as num?)?.toDouble(),
      peakPct: (json["peak_pct"] as num?)?.toDouble(),
      currentPct: (json["current_pct"] as num?)?.toDouble(),
      pnlUsd: (json["pnl_usd"] as num?)?.toDouble(),
      closedAt: json["closed_at"],
    );
  }
}

class TradeModel {
  final String tradeId;
  final String? direction;
  final String? openedAt;
  final double? spotPrice;
  final double totalPnlUsd;
  final String status;
  final List<TradeLegResult> legs;

  TradeModel({
    required this.tradeId,
    required this.direction,
    required this.openedAt,
    required this.spotPrice,
    required this.totalPnlUsd,
    required this.status,
    required this.legs,
  });

  factory TradeModel.fromJson(Map<String, dynamic> json) {
    return TradeModel(
      tradeId: json["trade_id"] ?? "",
      direction: json["direction"],
      openedAt: json["opened_at"],
      spotPrice: (json["spot_price"] as num?)?.toDouble(),
      totalPnlUsd: (json["total_pnl_usd"] as num?)?.toDouble() ?? 0.0,
      status: json["status"] ?? "OPEN",
      legs: (json["legs"] as List<dynamic>? ?? [])
          .map((e) => TradeLegResult.fromJson(e))
          .toList(),
    );
  }
}
