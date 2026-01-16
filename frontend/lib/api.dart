import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {
  final String baseUrl = "https://proconnectnb-d2bxe6embxg2e7h7.eastus2-01.azurewebsites.net";

  Future<String> getUser() async {
    try {
      final url = Uri.parse("$baseUrl/api/users/1"); // Exemple avec l'ID utilisateur 1

      print("URL: $url"); // Log de l'URL

      final response = await http.get(url); // Utilisation de http.get

      print("Status: ${response.statusCode}");

      if (response.statusCode == 200) 
      {
        return response.body;
      } 
      else if 
      (response.statusCode == 404) 
      {
        return "Utilisateur introuvable";
      } 
      else 
      {
        return "Erreur: ${response.statusCode}";
      }
    } 
    catch (ex) 
    {
      return "Exception: $ex";
    }
  }

  Future<String> getTest() async {
    final client = HttpClient();

    try 
    {
      print(baseUrl);

      final HttpClientRequest request = await client.getUrl(Uri.parse("$baseUrl/api/users/test"),);

      final HttpClientResponse response = await request.close();

      if (response.statusCode == 200) 
      {
        final String body = await response.transform(utf8.decoder).join();
        return body;
      }
      else 
      {
        return "Erreur: ${response.statusCode}";
      }
    } 
    catch (ex) 
    {
      return "Exception durant l'exécution du api Test: $ex";
    } 
    finally 
    {
      client.close();
    }
  }

}