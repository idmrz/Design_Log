import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class TokenManager {
  final String _tokenKey = "jwt_token";

  Future<bool> storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_tokenKey, token);
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? "";
  }

  Future<bool> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_tokenKey);
  }
}

Future<void> fetchUserData(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/user'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    // Parse the user data from the response body
    var userData = jsonDecode(response.body);

      // Kullanıcı verisini işleyin (örneğin, SharedPreferences'e kaydedin)
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_data', jsonEncode(userData));

  print("Kullanıcı verisi kaydedildi: $userData");
  }
}