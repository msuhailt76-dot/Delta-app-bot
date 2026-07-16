import 'package:flutter/material.dart';
import '../models/position_leg_model.dart';
import 'info_card.dart';

class LegCard extends StatelessWidget {
  final PositionLegModel leg;

  const LegCard({super.key, required this.leg});

  @override
  Widget build(BuildContext context) {
    final isMain = leg.leg == "main";
    final pnl = leg.pnlUsd ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Chip(
                      label: Text(isMain ? "MAIN" : "HEDGE"),
                      backgroundColor: isMain ? Colors.blueGrey : Colors.deepPurple,
                      labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      leg.optionType.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "${pnl >= 0 ? '+' : ''}\$${pnl.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: profitColor(pnl),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(leg.symbol, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _stat("Entry", "\$${leg.entryPremium.toStringAsFixed(2)}")),
                Expanded(
                  child: _stat(
                    "Current",
                    leg.currentPremium != null
                        ? "\$${leg.currentPremium!.toStringAsFixed(2)}"
                        : "-",
                  ),
                ),
                Expanded(child: _stat("Qty", leg.qty.toStringAsFixed(0))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _stat(
                    "Current %",
                    "${leg.currentPct >= 0 ? '+' : ''}${leg.currentPct.toStringAsFixed(1)}%",
                    color: profitColor(leg.currentPct),
                  ),
                ),
                Expanded(
                  child: _stat("Peak %", "${leg.peakPct.toStringAsFixed(1)}%"),
                ),
                Expanded(child: _stat("Open Since", leg.durationLabel)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
