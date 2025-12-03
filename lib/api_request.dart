import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> generateText(String prompt) async {
  final response = await http.post(
    Uri.parse(
      'http://10.0.2.2:3001/generate',
    ), // Android emulator-д зориулсан localhost
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'prompt': prompt}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['text'];
  } else {
    throw Exception('Failed to generate text');
  }
}
