import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _urlController = TextEditingController();
  final ApiClient _api = ApiClient();
  final AuthService _auth = AuthService();
  bool _saved = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    final url = await ApiClient.getBaseUrl();
    setState(() => _urlController.text = url);
  }

  Future<void> _saveUrl() async {
    await ApiClient.setBaseUrl(_urlController.text.trim());
    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _confirmAndSend(String title, String message, String path) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Confirm", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _busy = true);
    try {
      await _api.post(path, {});
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Command sent.")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: $e")));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Server", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: "API URL",
              hintText: "http://192.168.1.10:8000",
              border: const OutlineInputBorder(),
              suffixIcon: _saved ? const Icon(Icons.check, color: Colors.greenAccent) : null,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: _saveUrl, child: const Text("Save")),
          ),
          const SizedBox(height: 28),
          const Text("Bot Controls", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.warning_amber, color: Colors.orangeAccent),
                  title: const Text("Emergency Close"),
                  subtitle: const Text("Force-close all open legs immediately"),
                  onTap: _busy
                      ? null
                      : () => _confirmAndSend(
                            "Emergency Close",
                            "This will immediately close all open option legs at market price. Continue?",
                            "/control/close",
                          ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                  title: const Text("Stop Bot"),
                  subtitle: const Text("Bot will shut down cleanly (no auto-restart)"),
                  onTap: _busy
                      ? null
                      : () => _confirmAndSend(
                            "Stop Bot",
                            "This will stop the trading bot. It will NOT reopen automatically. Continue?",
                            "/control/stop",
                          ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
