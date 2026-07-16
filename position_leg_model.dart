class PositionLegModel {
  final String leg; // "main" or "hedge"
  final String symbol;
  final String optionType; // "call" / "put"
  final double qty;
  final double entryPremium;
  final double? currentPremium;
  final double currentPct;
  final double peakPct;
  final double? pnlUsd;
  final int? durationSeconds;

  PositionLegModel({
    required this.leg,
    required this.symbol,
    required this.optionType,
    required this.qty,
    required this.entryPremium,
    required this.currentPremium,
    required this.currentPct,
    required this.peakPct,
    required this.pnlUsd,
    required this.durationSeconds,
  });

  factory PositionLegModel.fromJson(Map<String, dynamic> json) {
    return PositionLegModel(
      leg: json["leg"] ?? "",
      symbol: json["symbol"] ?? "",
      optionType: json["option_type"] ?? "",
      qty: (json["qty"] as num?)?.toDouble() ?? 0,
      entryPremium: (json["entry_premium"] as num?)?.toDouble() ?? 0,
      currentPremium: (json["current_premium"] as num?)?.toDouble(),
      currentPct: (json["current_pct"] as num?)?.toDouble() ?? 0,
      peakPct: (json["peak_pct"] as num?)?.toDouble() ?? 0,
      pnlUsd: (json["pnl_usd"] as num?)?.toDouble(),
      durationSeconds: json["duration_seconds"],
    );
  }

  String get durationLabel {
    final s = durationSeconds;
    if (s == null) return "-";
    final m = s ~/ 60;
    final sec = s % 60;
    if (m == 0) return "${sec}s";
    return "${m}m ${sec}s";
  }
}
