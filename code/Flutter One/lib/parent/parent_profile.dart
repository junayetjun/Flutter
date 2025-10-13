import 'package:dreamjob/service/authservice.dart';
import 'package:flutter/material.dart';

class ParentProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  ParentProfile({Key? key, required this.profile}) : super(key: key);

  void onLogout(BuildContext context) {
    _authService.logout(); // Call logout if you have a method
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Profile'),
        backgroundColor: Colors.blue.shade800,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: (profile['photo'] != null && profile['photo'].isNotEmpty)
                    ? NetworkImage(profile['photo'])
                    : null,
                child: (profile['photo'] == null || profile['photo'].isEmpty)
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              accountName: Text(profile['parentName'] ?? 'Parent Name'),
              accountEmail: const Text('Parent'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile/edit'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () => onLogout(context),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (profile['photo'] != null && profile['photo'].isNotEmpty)
                        ? NetworkImage(profile['photo'])
                        : null,
                    child: (profile['photo'] == null || profile['photo'].isEmpty)
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // Profile Details
                _infoRow(Icons.person, "Parent Name", profile['parentName'] ?? ''),
                _infoRow(Icons.person_outline, "Contact Person", profile['contactPerson'] ?? ''),
                _infoRow(Icons.email, "Email", profile['email'] ?? ''),
                _infoRow(Icons.phone, "Phone", profile['phone'] ?? ''),
                _infoRow(Icons.home, "Address", profile['address'] ?? ''),
                _infoRow(Icons.child_care, "Child Name", profile['childName'] ?? ''),
                _infoRow(Icons.wc, "Gender", profile['gender'] ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
