

import 'package:dreamjob/page/loginpage.dart';
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
               backgroundImage: (photoUrl != null )
              ? NetworkImage(photoUrl)
              : const AssetImage('')
              as ImageProvider,
            ),
            ),
            // 🟣 Menu Items (you can add more later)
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.details),
              title: const Text('Summary'),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Applied Jobs'),
              onTap: () {
                // TODO: Navigate to applied jobs page
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Open settings page
                Navigator.pop(context);
              },
            ),

            const Divider(), // Thin line separator

            // 🔴 Logout Option
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                // Clear stored token and user role
                await _authService.logout();

                // Navigate back to login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),





      // ----------------------------
      // BODY: Main content area
      // ----------------------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🟣 Profile Picture Section
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Ensures circular border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.purple, // Border color around image
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 60, // Image size
                backgroundColor: Colors.grey[200],
                backgroundImage: (photoUrl != null)
                    ? NetworkImage(photoUrl) // From backend
                    : const AssetImage('')
                as ImageProvider, // Local default image
              ),
            ),

            const SizedBox(height: 20),

            // 🟣 Display Job Seeker Name
            Text(
              profile['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🟣 Display User Email (nested under user object)
            Text(
              "Email: ${profile['user']?['email'] ?? 'N/A'}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 10),

            // 🟣 Display Skills
            Text(
              "Skills: ${profile['skills'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // 🟣 Button for Editing Profile
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add edit functionality or navigation
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

