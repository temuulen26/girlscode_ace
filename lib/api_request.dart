import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generateText(String prompt) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3001/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['text'] ?? "Хоосон хариу ирлээ.";
    } else {
      return "Error: ${response.statusCode}";
    }
  } catch (e) {
    return "AI request failed: $e";
  }
}
