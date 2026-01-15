import 'dart:convert';
import 'dart:io';

class Api {
  final String baseUrl = "http://10.0.2.2:5000"; // change to your backend (render) URL

  Future<String> getMessage() async {
    final client = HttpClient();

    try {
      final request = await client.getUrl(Uri.parse("$baseUrl/api/users/1"));
      final response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        return body;
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    } finally {
      client.close();
    }
  }
}