import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/dashboard_model.dart';
import '../services/api_client.dart';
import '../widgets/info_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiClient _api = ApiClient();
  DashboardModel? _dashboard;
  Timer? _timer;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final json = await _api.get("/dashboard");
      if (!mounted) return;
      setState(() {
        _dashboard = DashboardModel.fromJson(json);
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = "Could not reach server");
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _dashboard;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: RefreshIndicator(
        onRefresh: _load,
        child: d == null
            ? ListView(
                children: [
                  const SizedBox(height: 120),
                  if (_error != null)
                    Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent)))
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  Card(
                    color: d.botRunning ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                    child: ListTile(
                      leading: Icon(
                        d.botRunning ? Icons.check_circle : Icons.cancel,
                        color: d.botRunning ? Colors.greenAccent : Colors.redAccent,
                      ),
                      title: Text(d.botRunning ? "Bot Running" : "Bot Stopped",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(d.positionOpen ? "Position: OPEN" : "Position: none"),
                      trailing: Icon(
                        d.internetConnected ? Icons.wifi : Icons.wifi_off,
                        color: d.internetConnected ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                    children: [
                      InfoCard(
                        title: "Today's P&L",
                        value: "\$${d.todayProfit.toStringAsFixed(2)}",
                        valueColor: profitColor(d.todayProfit),
                        icon: Icons.today,
                      ),
                      InfoCard(
                        title: "Overall P&L",
                        value: "\$${d.overallProfit.toStringAsFixed(2)}",
                        valueColor: profitColor(d.overallProfit),
                        icon: Icons.savings_outlined,
                      ),
                      InfoCard(
                        title: "Win Rate",
                        value: "${d.winRate.toStringAsFixed(1)}%",
                        icon: Icons.emoji_events_outlined,
                      ),
                      InfoCard(
                        title: "Trades Opened",
                        value: "${d.totalTradesOpened}",
                        icon: Icons.swap_horiz,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InfoCard(
                    title: "BTC Price",
                    value: d.btcPrice > 0 ? "\$${d.btcPrice.toStringAsFixed(1)}" : "-",
                    icon: Icons.currency_bitcoin,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      d.lastUpdate.isNotEmpty
                          ? "Last updated: ${DateFormat.Hms().format(DateTime.tryParse(d.lastUpdate)?.toLocal() ?? DateTime.now())}"
                          : "",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
