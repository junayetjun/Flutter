

import 'package:dreamjob/service/authservice.dart';
import 'package:flutter/material.dart';

class CaregiverProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService(); // Create instance of AuthService

  CaregiverProfile({Key? key, required this.profile}): super(key: key);

  @override
  Widget build(BuildContext context) {

    // ----------------------------
    // BASE URL for loading images
    // ----------------------------
    final String baseUrl ="http://localhost:8085/images/caregiver/";

    // Photo filename returned from backend (e.g., "john_doe.png")
    final String? photoName = profile['photo'];

    // Build full photo URL only if photo exists
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;


    // ----------------------------
    // SCAFFOLD: Main screen layout
    // ----------------------------
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caregiver profile",
        style: TextStyle(
          color: Colors.white
        ),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
        elevation: 4,
      ),


      // ----------------------------
      // DRAWER: Side navigation menu
      // ----------------------------
      drawer: Drawer(

        child: ListView(

          padding: EdgeInsets.zero, // Removes extra top padding
          children: [
            // 🟣 Drawer Header with user info
            UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.purple),
                accountName: Text(
                  profile['name'] ?? 'Unknown User', // Show job seeker name
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(profile['user'] ? ['email'] ?? 'N/A'),
            currentAccountPicture: CircleAvatar(
              // backgroundImage: (photoUrl != null ),
            ),)

          ],
        ),
      ),
    );
  }
}

