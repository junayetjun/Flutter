

import 'dart:convert';
import 'package:dreamjob/entity/job.dart';
import 'package:dreamjob/entity/job_dto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class JobService {
  final String baseUrl = 'http://localhost:8085/api/jobs/';

  // Get authorization header if token is available
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Create a job
  Future<Job> createJob(Map<String, dynamic> data) async {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create job: ${response.body}');
    }
  }

  // Get jobs by employer (parent) ID
  Future<List<Job>> getJobsByParentId(int parentId) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('${baseUrl}parent/$parentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Job.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load jobs by parent ID');
    }
  }

  // Delete a job by ID
  Future<void> deleteJob(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete job');
    }
  }

  // Update a job
  Future<Job> updateJob(int id, Map<String, dynamic> data) async {
    final headers = await _getAuthHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl$id'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Job.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update job');
    }
  }

  // Get job by ID
  Future<JobDTO> getJobById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return JobDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch job details');
    }
  }

  // Get all jobs
  Future<List<JobDTO>> getAllJobs() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => JobDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  // Search jobs with optional filters
  Future<List<JobDTO>> searchJobs({int? categoryId, int? locationId}) async {
    final Map<String, String> queryParams = {};

    if (categoryId != null) queryParams['categoryId'] = categoryId.toString();
    if (locationId != null) queryParams['locationId'] = locationId.toString();

    final uri = Uri.parse('${baseUrl}search').replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => JobDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search jobs');
    }
  }

  // Get jobs of logged-in employer
  Future<List<JobDTO>> getMyJobs() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('${baseUrl}my-jobs'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => JobDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch your jobs');
    }
  }
}
