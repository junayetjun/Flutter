


import 'dart:convert';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:http/http.dart' as http;

class CaregiverService{

  final String baseUrl = "http://localhost:8085";

  Future<Map<String, dynamic>?> getCaregiverProfile() async{
    String? token = await AuthService().getToken();

    if(token == null){
      print('No token found, please login first. ');
      return null;
    }

    final url = Uri.parse('$baseUrl/api/caregiver/profile');
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