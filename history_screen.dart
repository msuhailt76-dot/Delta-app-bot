import 'package:flutter/material.dart';

import '../models/trade_model.dart';
import '../services/api_client.dart';
import '../widgets/info_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ApiClient _api = ApiClient();
  List<TradeModel> _all = [];
  List<TradeModel> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final json = await _api.get("/history");
      final trades = (json["history"] as List<dynamic>)
          .map((e) => TradeModel.fromJson(e))
          .toList();

      if (!mounted) return;
      setState(() {
        _all = trades;
        _filtered = trades;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = "Could not reach server";
      });
    }
  }

  void _filter(String keyword) {
    setState(() {
      _filtered = _all
          .where((t) =>
              t.tradeId.toLowerCase().contains(keyword.toLowerCase()) ||
              (t.direction ?? "").toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trade History"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              onChanged: _filter,
              decoration: const InputDecoration(
                hintText: "Search by trade id or direction...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      const SizedBox(height: 100),
                      Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                    ],
                  )
                : _filtered.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 100),
                          Center(child: Text("No trades yet", style: TextStyle(color: Colors.grey))),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: _filtered.length,
                        itemBuilder: (context, i) => _tradeCard(_filtered[i]),
                      ),
      ),
    );
  }

  Widget _tradeCard(TradeModel t) {
    final win = t.totalPnlUsd >= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: win ? Colors.green : Colors.red,
          child: Text(t.direction?.substring(0, 1) ?? "?"),
        ),
        title: Text("${t.direction ?? '-'}  •  ${t.status}"),
        subtitle: Text(t.openedAt ?? ""),
        trailing: Text(
          "${t.totalPnlUsd >= 0 ? '+' : ''}\$${t.totalPnlUsd.toStringAsFixed(2)}",
          style: TextStyle(
            color: profitColor(t.totalPnlUsd),
            fontWeight: FontWeight.bold,
          ),
        ),
        children: t.legs
            .map(
              (leg) => ListTile(
                dense: true,
                title: Text("${leg.leg.toUpperCase()} - ${leg.symbol}"),
                subtitle: Text("Reason: ${leg.reason}"),
                trailing: Text(
                  leg.pnlUsd != null
                      ? "\$${leg.pnlUsd!.toStringAsFixed(2)}"
                      : "-",
                  style: TextStyle(color: profitColor(leg.pnlUsd ?? 0)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
