import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const _storage = FlutterSecureStorage();
  static const String _defaultBaseUrl = "http://YOUR_SERVER_IP:8000";

  static Future<String> getBaseUrl() async {
    return await _storage.read(key: "api_base_url") ?? _defaultBaseUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    await _storage.write(key: "api_base_url", value: url);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: "jwt_token");
  }

  static Future<void> setToken(String token) async {
    await _storage.write(key: "jwt_token", value: token);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: "jwt_token");
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> get(String path) async {
    final base = await getBaseUrl();
    final response = await http
        .get(Uri.parse("$base$path"), headers: await _authHeaders())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, response.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body,
      {bool auth = true}) async {
    final base = await getBaseUrl();
    final response = await http
        .post(
          Uri.parse("$base$path"),
          headers: auth ? await _authHeaders() : {"Content-Type": "application/json"},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, response.body);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);

  @override
  String toString() => "ApiException($statusCode): $body";
}
