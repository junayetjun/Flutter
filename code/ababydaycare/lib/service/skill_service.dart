

import 'dart:convert';
import 'package:ababydaycare/entity/skill.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class SkillService {
  final String baseUrl = 'http://localhost:8085/api/skill/all'; // ⚙️ Change if needed

  /// Fetch all skills
  Future<List<Skill>> fetchSkills() async {
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
      return body.map((json) => Skill.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load skills: ${response.body}');
    }
  }

  /// Fetch single skill by ID
  Future<Skill> fetchSkillById(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Skill.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch skill: ${response.body}');
    }
  }

  /// Add new skill
  Future<Skill> addSkill(Skill skill) async {
    String? token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(skill.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Skill.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add skill: ${response.body}');
    }
  }

  /// Update skill
  Future<Skill> updateSkill(Skill skill) async {
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${skill.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(skill.toJson()),
    );

    if (response.statusCode == 200) {
      return Skill.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update skill: ${response.body}');
    }
  }

  /// Delete skill by ID
  Future<void> deleteSkill(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete skill: ${response.body}');
    }
  }
}
