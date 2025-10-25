import 'dart:convert';
import 'package:ababydaycare/DTO/apply_dto.dart';
import 'package:http/http.dart' as http;

class ApplyService {
  final String baseUrl = 'http://localhost:8085/api/applications';

  // Headers for auth
  Map<String, String> headers(String? token) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // ✅ Create a new application
  Future<ApplyDTO> createApplication(Map<String, dynamic> applyPayload, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers(token),
      body: json.encode(applyPayload),
    );

    if (response.statusCode == 200) {
      return ApplyDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create application: ${response.body}');
    }
  }

  // ✅ Get all applications (admin only)
  Future<List<ApplyDTO>> getAllApplications(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ApplyDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all applications');
    }
  }

  // ✅ Get application by ID
  Future<ApplyDTO> getApplicationById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: headers(token),
    );

    if (response.statusCode == 200) {
      return ApplyDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Application not found');
    }
  }

  // ✅ Get caregiver’s own applications (authenticated)
  Future<List<ApplyDTO>> getMyApplications(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/my'),
      headers: headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ApplyDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load your applications');
    }
  }

  // ✅ Get applications for job (parent role)
  Future<List<ApplyDTO>> getApplicationsForJob(int jobId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/applicant/$jobId'),
      headers: headers(token),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => ApplyDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load applications for job');
    }
  }

  // ✅ Update an application
  Future<bool> updateApplication(int id, Map<String, dynamic> payload, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers(token),
      body: json.encode(payload),
    );

    return response.statusCode == 200;
  }

  // ✅ Delete application
  Future<bool> deleteApplication(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers(token),
    );

    return response.statusCode == 204;
  }
}
