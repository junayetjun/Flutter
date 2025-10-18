import 'dart:convert';
import 'package:dreamjob/entity/job.dart';
import 'package:dreamjob/entity/job_dto.dart';
import 'package:dreamjob/service/authservice.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobService {
  final String baseUrl = 'http://localhost:8085/api/jobs/';
  final AuthService _authService = AuthService();

  /// ✅ Common headers (with JWT)
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  /// ✅ Create new job (POST /api/jobs/)
  Future<Job> createJob(Job job) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(job.toJson()), // Must match backend JSON
    );

    print("📤 Sending job: ${jsonEncode(job.toJson())}");
    print("📥 Response: ${response.statusCode} -> ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to create job (status ${response.statusCode}): ${response.body}');
    }
  }

  /// ✅ Get all jobs (public endpoint)
  Future<List<JobDTO>> getAllJobs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => JobDTO.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to fetch jobs: ${response.body}');
    }
  }

  /// ✅ Get logged-in parent's jobs (GET /api/jobs/my-jobs)
  Future<List<Job>> getMyJobs() async {
    String? token = await AuthService().getToken();
    final headers = await _getAuthHeaders();
    final url = Uri.parse('${baseUrl}my-jobs');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Job.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch your jobs');
    }
  }



  /// ✅ Get a job by ID (GET /api/jobs/{id})
  Future<JobDTO> getJobById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return JobDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get job details: ${response.body}');
    }
  }

  /// ✅ Delete job (DELETE /api/jobs/{id})
  Future<void> deleteJob(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete job: ${response.body}');
    }
  }

  /// ✅ Search jobs (GET /api/jobs/search?categoryId&locationId)
  Future<List<JobDTO>> searchJobs({int? categoryId, int? locationId}) async {
    final queryParams = <String, String>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId.toString();
    if (locationId != null) queryParams['locationId'] = locationId.toString();

    final uri = Uri.parse('${baseUrl}search').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => JobDTO.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to search jobs: ${response.body}');
    }
  }

  /// ✅ Update job (PUT /api/jobs/{id})
  Future<JobDTO> updateJob(int id, JobDTO job) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: headers,
      body: jsonEncode(job.toJson()),
    );

    if (response.statusCode == 200) {
      return JobDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update job: ${response.body}');
    }
  }


}
