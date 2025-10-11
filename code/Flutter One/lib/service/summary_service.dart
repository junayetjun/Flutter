


import 'package:dreamjob/service/authservice.dart';

class SummaryService{

  final String baseUrl = "http://localhost:8085";

  Future<Map<String, dynamic>?> getCaregiverSummary() async{

    String? token = await AuthService().getToken();

    if(token == null){

      print('No token found, please login first');
      return null;
    }

    // final url = Uri.parse('$baseUrl')




  }


}