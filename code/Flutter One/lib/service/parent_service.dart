




import 'dart:convert';

import 'package:dreamjob/service/authservice.dart';
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




}