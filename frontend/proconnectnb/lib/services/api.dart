import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'secrets.dart';
import '../models/medication.dart';
class Api {
  final String baseUrl =
      "https://proconnectnb-d2bxe6embxg2e7h7.eastus2-01.azurewebsites.net";

  // ===============================
  // HEADERS PAR DÉFAUT
  // ===============================
  Map<String, String> defaultHeaders() {
    return {
      "Content-Type": "application/json",
      "x-api-key": Secrets.apiKey
    };
  }

  // ===============================
  // GET USER (EXISTANT)
  // ===============================
  Future<String> getUser() async {
    try {
      final url = Uri.parse("$baseUrl/api/users/1");

      print("URL: $url");

      final response = await http.get(
        url,
        headers: defaultHeaders(), // ✅ correction ici
      );

      print("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        return "Utilisateur introuvable";
      } else {
        return "Erreur: ${response.statusCode}";
      }
    } catch (ex) {
      return "Exception: $ex";
    }
  }

  // ===============================
  // TEST API (EXISTANT)
  // ===============================
  Future<String> getTest() async {
    final client = HttpClient();

    try {
      print(baseUrl);

      final HttpClientRequest request =
          await client.getUrl(Uri.parse("$baseUrl/api/users/test"));

      final HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        final String body =
            await response.transform(utf8.decoder).join();
        return body;
      } else {
        return "Erreur: ${response.statusCode}";
      }
    } catch (ex) {
      return "Exception durant l'exécution du api Test: $ex";
    } finally {
      client.close();
    }
  }

  // ===============================
  // LOGIN MOCK (TEMPORAIRE)
  // ===============================
  Future<bool> loginMock(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == "test@test.com" && password == "1234") {
      return true;
    } else {
      return false;
    }
  }

  // ===============================
  // FUTUR LOGIN (PRÊT POUR BACKEND)
  // ===============================
  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/api/auth/login");

      final response = await http.post(
        url,
        headers: defaultHeaders(),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Erreur de connexion: $e");
      return false;
    }
  }

  // ===============================
  // GET MEDICAMENTS
  // ===============================
  Future<List<dynamic>> getMedications() async {
    try {
      final url = Uri.parse("$baseUrl/api/medicaments");

      final response = await http.get(
        url,
        headers: defaultHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Erreur chargement médicaments");
      }
    } catch (e) {
      print("Erreur API médicaments: $e");
      return [];
    }
  }

  // ===============================
  // ADD MEDICAMENT
  // ===============================
  Future<bool> addMedication(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("$baseUrl/api/medicaments");

      final response = await http.post(
        url,
        headers: defaultHeaders(),
        body: jsonEncode(data),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Erreur ajout médicament: $e");
      return false;
    }
  }
}