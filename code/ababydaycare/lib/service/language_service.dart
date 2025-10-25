

import 'dart:convert';
import 'package:ababydaycare/entity/language.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class LanguageService {
  final String baseUrl = 'http://localhost:8085/api/language/all'; // ✅ Change to your real backend URL

  /// Fetch all languages
  Future<List<Language>> fetchLanguages() async {
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
      return body.map((json) => Language.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load languages: ${response.body}');
    }
  }

  /// Fetch single language by ID
  Future<Language> fetchLanguageById(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Language.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load language: ${response.body}');
    }
  }

  /// Add a new language
  Future<Language> addLanguage(Language language) async {
    String? token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(language.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Language.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add language: ${response.body}');
    }
  }

  /// Update existing language
  Future<Language> updateLanguage(Language language) async {
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${language.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(language.toJson()),
    );

    if (response.statusCode == 200) {
      return Language.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update language: ${response.body}');
    }
  }

  /// Delete language by ID
  Future<void> deleteLanguage(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete language: ${response.body}');
    }
  }
}
