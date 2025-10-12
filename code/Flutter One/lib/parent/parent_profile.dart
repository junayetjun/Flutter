

import 'package:dreamjob/service/authservice.dart';
import 'package:flutter/material.dart';

class ParentProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService(); // Create instance of AuthService

  ParentProfile({Key? key, required this.profile}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
