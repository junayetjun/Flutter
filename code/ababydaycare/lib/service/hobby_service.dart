

import 'dart:convert';
import 'package:ababydaycare/entity/hobby.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class HobbyService {
  final String baseUrl = 'http://localhost:8085/api/hobby/all'; // ✅ Replace with your actual API base URL

  /// Fetch all hobbies
  Future<List<Hobby>> fetchHobbies() async {
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
      return body.map((json) => Hobby.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hobbies: ${response.body}');
    }
  }

  /// Add new hobby
  Future<Hobby> addHobby(Hobby hobby) async {
    String? token = await AuthService().getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hobby.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Hobby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add hobby: ${response.body}');
    }
  }

  /// Update hobby
  Future<Hobby> updateHobby(Hobby hobby) async {
    String? token = await AuthService().getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/${hobby.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(hobby.toJson()),
    );

    if (response.statusCode == 200) {
      return Hobby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update hobby: ${response.body}');
    }
  }

  /// Delete hobby by ID
  Future<void> deleteHobby(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete hobby: ${response.body}');
    }
  }

  /// Fetch a single hobby by ID
  Future<Hobby> fetchHobbyById(int id) async {
    String? token = await AuthService().getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Hobby.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load hobby: ${response.body}');
    }
  }
}
