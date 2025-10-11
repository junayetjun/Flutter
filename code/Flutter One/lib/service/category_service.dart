import 'dart:convert';
import 'package:dreamjob/entity/category.dart';
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
}
