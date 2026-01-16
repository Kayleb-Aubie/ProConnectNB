import 'dart:convert';
import 'dart:io';

class Api {
  final String baseUrl ="https://proconnectnb-d2bxe6embxg2e7h7.eastus2-01.azurewebsites.net"; // URL (Azure backend)

  Future<String> getUser() async {
    final client = HttpClient();

    try {
      print(baseUrl);

      final HttpClientRequest request = await client.getUrl(Uri.parse("$baseUrl/api/users/1"),);

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
      return "Exception durant l'exécution du api DB: $ex";
    } 
    finally 
    {
      client.close();
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