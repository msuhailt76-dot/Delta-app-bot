class DashboardModel {
  final bool botRunning;
  final bool internetConnected;
  final bool positionOpen;
  final double todayProfit;
  final int todayTrades;
  final double overallProfit;
  final double winRate;
  final int totalTradesOpened;
  final int totalLegExits;
  final double btcPrice;
  final Map<String, dynamic>? lastSignal;
  final String lastUpdate;

  DashboardModel({
    required this.botRunning,
    required this.internetConnected,
    required this.positionOpen,
    required this.todayProfit,
    required this.todayTrades,
    required this.overallProfit,
    required this.winRate,
    required this.totalTradesOpened,
    required this.totalLegExits,
    required this.btcPrice,
    required this.lastSignal,
    required this.lastUpdate,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      botRunning: json["bot_running"] ?? false,
      internetConnected: json["internet_connected"] ?? false,
      positionOpen: json["position_open"] ?? false,
      todayProfit: (json["today_profit"] as num?)?.toDouble() ?? 0.0,
      todayTrades: json["today_trades"] ?? 0,
      overallProfit: (json["overall_profit"] as num?)?.toDouble() ?? 0.0,
      winRate: (json["win_rate"] as num?)?.toDouble() ?? 0.0,
      totalTradesOpened: json["total_trades_opened"] ?? 0,
      totalLegExits: json["total_leg_exits"] ?? 0,
      btcPrice: (json["btc_price"] as num?)?.toDouble() ?? 0.0,
      lastSignal: json["last_signal"] as Map<String, dynamic>?,
      lastUpdate: json["last_update"] ?? "",
    );
  }
}
