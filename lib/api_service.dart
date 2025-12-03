import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000";

  // -------------------
  // User бүртгүүлэх
  // -------------------
  static Future<Map<String, dynamic>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Register Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }

  // -------------------
  // Login хийх
  // -------------------
  static Future<Map<String, dynamic>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Login Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }

  // -------------------
  // Profile авах
  // -------------------
  static Future<Map<String, dynamic>> getProfile(String username) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profile/$username"),
        headers: {"Content-Type": "application/json"},
      );
      return jsonDecode(response.body);
    } catch (e) {
      print("Profile Error: $e");
      return {"status": "error", "message": e.toString()};
    }
  }
}
