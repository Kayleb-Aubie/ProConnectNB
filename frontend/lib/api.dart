import 'dart:convert';
import 'dart:io';

class Api {
  final String baseUrl = "https://proconnectnb-d2bxe6embxg2e7h7.eastus2-01.azurewebsites.net/api/users/test"; // URL (Azure backend)

  Future<String> getMessage() async {
    final client = HttpClient();

    try 
    {
      final request = await client.getUrl(Uri.parse("$baseUrl/api/users/test"));
      final response = await request.close();

      if (response.statusCode == 200) 
      {
        final body = await response.transform(utf8.decoder).join();
        return body;
      } 
      else 
      {
        return "Error: ${response.statusCode}";
      }
    } 
    catch (ex) 
    {
      return "Exception durant l'exécution du api: $ex";
    } 
    finally 
    {
      client.close();
    }

  }
}