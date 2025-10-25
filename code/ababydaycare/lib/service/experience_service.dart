
import 'dart:convert';
import 'package:ababydaycare/entity/experience.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class ExperienceService {
  final String baseUrl = 'http://localhost:8085/api/experience/all'; // ✅ Change to your actual API base URL

  /// Fetch all experiences
  Future<List<Experience>> fetchExperiences() async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // JWT Auth header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Experience.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load experiences: ${response.body}');
    }
  }

  /// Add new experience
  Future<Experience> addExperience(Experience experience) async {
    String? token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(experience.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Experience.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add experience: ${response.body}');
    }
  }

  /// Update existing experience
  Future<Experience> updateExperience(Experience experience) async {
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${experience.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(experience.toJson()),
    );

    if (response.statusCode == 200) {
      return Experience.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update experience: ${response.body}');
    }
  }

  /// Delete an experience by ID
  Future<void> deleteExperience(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete experience: ${response.body}');
    }
  }

  /// Fetch single experience by ID
  Future<Experience> fetchExperienceById(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Experience.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load experience: ${response.body}');
    }
  }
}
