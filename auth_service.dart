import 'api_client.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  Future<LoginResult> login(String username, String password) async {
    try {
      final json = await _api.post(
        "/login",
        {"username": username, "password": password},
        auth: false,
      );

      if (json["success"] == true) {
        await ApiClient.setToken(json["token"]);
        return LoginResult(success: true);
      }

      return LoginResult(
        success: false,
        message: json["message"] ?? "Invalid username or password",
      );
    } catch (e) {
      return LoginResult(success: false, message: "Could not reach server: $e");
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await ApiClient.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await ApiClient.clearToken();
  }
}

class LoginResult {
  final bool success;
  final String? message;
  LoginResult({required this.success, this.message});
}
