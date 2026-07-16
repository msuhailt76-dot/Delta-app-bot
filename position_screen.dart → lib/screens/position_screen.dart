import 'dart:async';
import 'package:flutter/material.dart';

import '../models/position_leg_model.dart';
import '../services/api_client.dart';
import '../widgets/leg_card.dart';

class PositionScreen extends StatefulWidget {
  const PositionScreen({super.key});

  @override
  State<PositionScreen> createState() => _PositionScreenState();
}

class _PositionScreenState extends State<PositionScreen> {
  final ApiClient _api = ApiClient();
  List<PositionLegModel>? _legs;
  double? _btcPrice;
  bool _open = false;
  Timer? _timer;
  String? _error;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final json = await _api.get("/position");
      if (!mounted) return;

      setState(() {
        _loaded = true;
        _error = null;
        _open = json["status"] == "OPEN";
        if (_open) {
          _btcPrice = (json["btc_price"] as num?)?.toDouble();
          _legs = (json["legs"] as List<dynamic>)
              .map((e) => PositionLegModel.fromJson(e))
              .toList();
        } else {
          _legs = [];
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loaded = true;
        _error = "Could not reach server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Current Position")),
      body: RefreshIndicator(
        onRefresh: _load,
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Center(child: Text(_error!, style: const TextStyle(color: Colors.redAccent))),
                    ],
                  )
                : !_open
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.hourglass_empty, size: 48, color: Colors.grey),
                                SizedBox(height: 12),
                                Text("No open position", style: TextStyle(color: Colors.grey)),
                                Text("Waiting for next entry signal...",
                                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.all(14),
                        children: [
                          if (_btcPrice != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                "BTC: \$${_btcPrice!.toStringAsFixed(1)}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ...?_legs?.map((leg) => LegCard(leg: leg)),
                        ],
                      ),
      ),
    );
  }
}
