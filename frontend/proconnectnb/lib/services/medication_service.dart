import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/medication.dart';
import 'api.dart';

class MedicationService {
  final Api _api = Api();

  Future<List<Medication>> getMedications(String token) async {
    try {
      final response = await http.get(
        Uri.parse("${_api.baseUrl}/api/Medicaments"),
        headers: _api.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded
              .whereType<Map>()
              .map(
                (item) => Medication.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
      }

      return [];
    } catch (e) {
      debugPrint("Erreur getMedications: $e");
      return [];
    }
  }

  Future<String?> uploadMedicationImage(String imagePath, String token) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        debugPrint("Image introuvable: $imagePath");
        return null;
      }

      final uri = Uri.parse("${_api.baseUrl}/api/images/upload");

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({'Authorization': 'Bearer $token'});

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
      debugPrint("Erreur uploadMedicationImage: $e");
      return null;
    }
  }

  Future<bool> createMedication(Map<String, dynamic> data, String token) async {
    try {
      final response = await http.post(
        Uri.parse("${_api.baseUrl}/api/Medicaments"),
        headers: _api.authHeaders(token),
        body: jsonEncode(data),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Erreur createMedication: $e");
      return false;
    }
  }

  Future<bool> updateMedication(
    int id,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("${_api.baseUrl}/api/Medicaments/$id"),
        headers: _api.authHeaders(token),
        body: jsonEncode(data),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Erreur updateMedication: $e");
      return false;
    }
  }

  Future<bool> deleteMedication(int id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("${_api.baseUrl}/api/Medicaments/$id"),
        headers: _api.authHeaders(token),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Erreur deleteMedication: $e");
      return false;
    }
  }

  Future<bool> toggleMedicationActive(
    int id,
    bool isActive,
    String token,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse("${_api.baseUrl}/api/Medicaments/$id/actif"),
        headers: _api.authHeaders(token),
        body: jsonEncode({"isActive": isActive}),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Erreur toggleMedicationActive: $e");
      return false;
    }
  }

  Future<bool> toggleMedicationTaken(int id, bool isTaken, String token) async {
    try {
      final response = await http.patch(
        Uri.parse("${_api.baseUrl}/api/Medicaments/$id/pris"),
        headers: _api.authHeaders(token),
        body: jsonEncode({"isTaken": isTaken}),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint("Erreur toggleMedicationTaken: $e");
      return false;
    }
  }
}
