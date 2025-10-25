
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

  final String baseUrl = "http://localhost:8085";

  Future<bool> login(String email, String password) async{

    final url = Uri.parse('$baseUrl/api/user/login');
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(url, headers: headers, body: body);


    if(response.statusCode == 200 || response.statusCode == 201){
      final data = jsonDecode(response.body);
      String token = data['token'];

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      // Store token and role
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setString('userRole', role);

      return true;
    }
    else{
      print('Failed to log in:  ${response.body}');

      return false;

    }
  }

  /// Registers a Caregiver (for Web & Mobile) by sending
  /// user data, caregiver data, and optional photo (file or bytes)

  Future<bool> registerCaregiverWeb({
    required Map<String, dynamic> user, // User data (username, email, password, etc.)
    required Map<String, dynamic> caregiver, // Caregiver-specific data (skills, CV, etc.)
    File? photoFile, // Photo file (used on mobile/desktop platforms)
    Uint8List? photoBytes, // Photo bytes (used on web platforms)

  }) async {
    // Create a multipart HTTP request (POST) to your backend API
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/caregiver/'), // Backend endpoint
    );

    // Convert User map into JSON string and add to request fields
    request.fields['user'] = jsonEncode(user);


    // Convert Caregiver map into JSON string and add to request fields
    request.fields['caregiver'] = jsonEncode(caregiver);


    // ---------------------- IMAGE HANDLING ----------------------

    // If photoBytes is available (e.g., from web image picker)

    if (photoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo',                // backend expects field name 'photo'
          photoBytes,             // Uint8List is valid here
          filename: 'profile.png' // arbitrary filename for backend
      ));
    }

    // If photoFile is provided (mobile/desktop), attach it
    else if (photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',                // backend expects field name 'photo'
        photoFile.path,         // file path from File object
      ));
    }

    // ---------------------- SEND REQUEST ----------------------

    // Send the request to backend
    var response = await request.send();

    // Return true if response code is 200 (success)
    return response.statusCode == 200;

  }



  /// Registers a Parent (for Web & Mobile) by sending
  /// user data, parent data, and optional photo (file or bytes)

  Future<bool> registerParentWeb({
    required Map<String, dynamic> user, // User data (username, email, password, etc.)
    required Map<String, dynamic> parent, // Caregiver-specific data (skills, CV, etc.)
    File? photoFile, // Photo file (used on mobile/desktop platforms)
    Uint8List? photoBytes, // Photo bytes (used on web platforms)

  }) async {
    // Create a multipart HTTP request (POST) to your backend API
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/parent/'), // Backend endpoint
    );

    // Convert User map into JSON string and add to request fields
    request.fields['user'] = jsonEncode(user);


    // Convert Parent map into JSON string and add to request fields
    request.fields['parent'] = jsonEncode(parent);


    // ---------------------- IMAGE HANDLING ----------------------

    // If photoBytes is available (e.g., from web image picker)

    if (photoBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo',                // backend expects field name 'photo'
          photoBytes,             // Uint8List is valid here
          filename: 'profile.png' // arbitrary filename for backend
      ));
    }

    // If photoFile is provided (mobile/desktop), attach it
    else if (photoFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'photo',                // backend expects field name 'photo'
        photoFile.path,         // file path from File object
      ));
    }

    // ---------------------- SEND REQUEST ----------------------

    // Send the request to backend
    var response = await request.send();

    // Return true if response code is 200 (success)
    return response.statusCode == 200;

  }




  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userRole'));
    return prefs.getString('userRole');

  }

  Future<String?> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<bool> isTokenExpired() async{
    String? token = await getToken();
    if(token!= null) {
      DateTime expiryDate =Jwt.getExpiryDate(token)!;
      return DateTime.now().isAfter(expiryDate);
    }
    return true;
  }


  Future<bool> isLoggedIn() async{
    String? token = await getToken();
    if(token!= null && !(await isTokenExpired())){
      return true;
    }
    else{
      await logout();
      return false;
    }
  }


  Future<void> logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userRole');
  }

  Future<bool> hasRole(List<String> roles) async{
    String? role = await getUserRole();
    return role!= null && roles.contains(role);
  }

  Future<bool> isAdmin() async{
    return await hasRole(['ADMIN']);
  }

  Future<bool> isCaregiver() async{
    return await hasRole(['CAREGIVER']);
  }

  Future<bool> isParent() async{
    return await hasRole(['PARENT']);
  }



// flutter run -d chrome --web-port=5000

}