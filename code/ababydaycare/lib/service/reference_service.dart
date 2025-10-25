

import 'dart:convert';
import 'package:ababydaycare/entity/reference.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class ReferenceService {
  final String baseUrl = 'http://localhost:8085/api/reference/all'; // ✅ Change to your actual backend URL

  /// Fetch all references
  Future<List<Reference>> fetchReferences() async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Reference.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load references: ${response.body}');
    }
  }

  /// Fetch a single reference by ID
  Future<Reference> fetchReferenceById(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Reference.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load reference: ${response.body}');
    }
  }

  /// Add a new reference
  Future<Reference> addReference(Reference reference) async {
    String? token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reference.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Reference.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add reference: ${response.body}');
    }
  }

  /// Update existing reference
  Future<Reference> updateReference(Reference reference) async {
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${reference.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reference.toJson()),
    );

    if (response.statusCode == 200) {
      return Reference.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update reference: ${response.body}');
    }
  }

  /// Delete reference by ID
  Future<void> deleteReference(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete reference: ${response.body}');
    }
  }
}
