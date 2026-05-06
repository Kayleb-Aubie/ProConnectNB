import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/medication.dart';
import 'api.dart';

class MedicationService {
  final Api _api = Api();

  Future<List<Medication>> getMedicaments(String token) async {
    final response = await http.get(
      Uri.parse("${_api.baseUrl}/api/medicaments"),
      headers: _api.authHeaders(token),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur ${response.statusCode}: ${response.body}");
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) return [];

    return decoded
        .map((e) => Medication.fromJson(e as Map<String, dynamic>))
        .where((m) => !m.isDeleted)
        .toList();
  }

  Future<String?> uploadMedicamentImage(
    String imagePath,
    String token,
  ) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        debugPrint("Image introuvable: $imagePath");
        return null;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${_api.baseUrl}/api/images/upload"),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded['url'] ??
              decoded['urlPhoto'] ??
              decoded['imageUrl'] ??
              decoded['fileUrl'];
        }
      }

      return null;
    } catch (e) {
      debugPrint("Erreur uploadMedicamentImage: $e");
      return null;
    }
  }

  Future<bool> createMedicament(Map<String, dynamic> body, String token) async {
    final response = await http.post(
      Uri.parse("${_api.baseUrl}/api/medicaments"),
      headers: _api.authHeaders(token),
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateMedicament(
    int id,
    Map<String, dynamic> body,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse("${_api.baseUrl}/api/medicaments/$id"),
      headers: _api.authHeaders(token),
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> deleteMedicament(int id, String token) async {
    final response = await http.delete(
      Uri.parse("${_api.baseUrl}/api/medicaments/$id"),
      headers: _api.authHeaders(token),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
