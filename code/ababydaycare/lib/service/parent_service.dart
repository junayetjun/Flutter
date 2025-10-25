




import 'dart:convert';

import 'package:ababydaycare/entity/parent.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class ParentService{

  final String baseUrl = "http://localhost:8085";

  Future<Map<String, dynamic>?> getParentProfile() async{
    String? token = await AuthService().getToken();

    if(token == null){
      print('No token found, please login first. ');
      return null;
    }

    final url = Uri.parse('$baseUrl/api/parent/profile');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    } else{
      print('Failed to lead profile: ${response.statusCode} - ${response.body}');
      return null;
    }
  }


  // ✅ Get all parents
  Future<List<Parent>> getAllParents() async {
    final response = await http.get(Uri.parse('${baseUrl}all'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Parent.fromJson(e)).toList();
    } else {
      throw Exception('❌ Failed to fetch parents');
    }
  }

  // ✅ Delete parent by ID
  Future<String> deleteParent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body;
    } else {
      throw Exception('❌ Failed to delete parent');
    }
  }




}