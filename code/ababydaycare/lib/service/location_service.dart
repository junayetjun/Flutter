import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/location.dart';

class LocationService {
  final String _baseUrl = 'http://localhost:8085/api/locations/';

  // Get authorization headers with token
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

  // GET all locations
  Future<List<Location>> getAllLocations() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Location.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  // POST create a new location
  Future<Location> createLocation(String name) async {
    final headers = await _getAuthHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Location.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create location: ${response.body}');
    }
  }

  // DELETE location by ID
  Future<void> deleteLocation(int id) async {
    final headers = await _getAuthHeaders();

    final response = await http.delete(
      Uri.parse("$_baseUrl$id"),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete location');
    }
  }
}
