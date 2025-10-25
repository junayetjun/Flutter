import 'dart:convert';
import 'package:ababydaycare/entity/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String baseUrl = 'http://localhost:8085'; // ✅ Update for production!

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  /// ✅ Get all categories from backend: GET /api/categories/
  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else if (response.statusCode == 204) {
      return []; // No content
    } else {
      throw Exception('Failed to load categories: ${response.body}');
    }
  }
}
